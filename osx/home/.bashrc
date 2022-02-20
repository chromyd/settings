if shopt -q login_shell; then
	export PS1="\[$(tput setaf 6)\]\w\[$(tput setaf 3)\]\$(git status -s 2>/dev/null | paste -s - | sed 's/.*/ */')\[$(tput setaf 2)\]\$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ &/')\[$(tput sgr0)\]$ "
else
	export PS1="\s-\v:\W\$ "
fi

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=/opt/apache-maven-3.0.5
export DERBY_INSTALL=/opt/glassfish4/javadb
export PATH=~/bin:$PATH
export LOG=/opt/wildfly/standalone/log/server.log
export CDPATH=~/ws

#export CLASSPATH=$DERBY_INSTALL/lib/derby.jar:$DERBY_INSTALL/lib/derbytools.jar:.

set -o vi


function nexus()
{
	fgrep /password ~/.m2/settings.xml | awk -F'[<>]' '{print $3}' | less
}

function dirty()
{
	git status | egrep 'new file:|modified:' | awk -F: '{print $2}' | awk '{print $1}' | sort | uniq
}

function mirror()
{
	if [ "$1" = "on" ]
	then
		ln -sf ~/.m2/settings-mirror.xml ~/.m2/settings.xml
		return
	fi

	if [ "$1" = "off" ]
	then
		ln -sf ~/.m2/settings-no-mirror.xml ~/.m2/settings.xml
		return
	fi

	echo 'Usage: mirror on|of'
	return -1
}

function fdeploy()
{
	/opt/wildfly/bin/jboss-cli.sh --connect --commands="deploy -f $(ls dist/*.war)"
}

function bdeploy()
{
	/opt/wildfly/bin/jboss-cli.sh --connect --commands="deploy -f $(ls target/*.war)"
}

function solrd()
{
	SOLR_DIR=/opt/solr/example

	if [ "$1" == "-r" ]; then
		echo ================ Resetting Solr cores ================
		RESOURCE_DIR=~/ws/mc_core_data_management_backend/resources
		rm -rf $SOLR_DIR/solr/{person,organization}

		cp -r $RESOURCE_DIR/solr/person $SOLR_DIR/solr/person
		cp -r $RESOURCE_DIR/solr/organization $SOLR_DIR/solr/organization

		cp -r /opt/solr-lib $SOLR_DIR/solr/person/lib
		cp -r /opt/solr-lib $SOLR_DIR/solr/organization/lib
	fi

	cd $SOLR_DIR
	java -jar start.jar
}

function mep()
{
	echo Make eclipse projects for BPMN 
	for x in $(find . -name project.imports)
	do (
		cd $(dirname $x)
		if [ -e .project ]
		then
			echo $(pwd): skipping
		else
			PROJECT_NAME=$(basename $(pwd))
			echo Instrumenting $PROJECT_NAME
			echo sed "s/PROJECT_NAME/$PROJECT_NAME/" ~/tmp/.project
			sed "s/PROJECT_NAME/$PROJECT_NAME/" ~/tmp/.project > .project
			echo cp ~/tmp/.classpath .
			cp ~/tmp/.classpath .
		fi
	)
	done
}


function mycnf()
{
	CNF=~/.my.cnf
	if [ -z "$1" ]
	then
		ls -o $CNF*
	else
		if [ ! -e $CNF-$1 ]
		then
			echo The target $CNF-$1 does not exist!
			return 1	
		fi
		ln -sf $CNF-$1 $CNF
		ls -o $CNF
	fi
}

function log()
{
	LOG=/opt/wildfly/standalone/log/server.log
	if [ -z "$1" ]
	then
		less +G $LOG
	else
		tail -f $LOG | fgrep -i "$*"
	fi
}

function logb()
{
	LOG=/opt/local/wildfly/standalone/log/server.log
	if [ -z "$1" ]
	then
		less +G $LOG
	else
		tail -f $LOG | fgrep -i "$*"
	fi
}

if [ -e ~/.bash_aliases ]
then
	. ~/.bash_aliases
fi

(echo Your functions:; typeset -F) | sed 's/declare -f //' | fgrep -v update_terminal_cwd | paste -s -
(echo Your aliases:; alias) | sed 's/alias //' | sed 's/=.*//' | paste -s -
