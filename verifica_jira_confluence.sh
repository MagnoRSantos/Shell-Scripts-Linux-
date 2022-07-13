#!/bin/bash

#Remove logs acima de 10 dias
#find /home/magnosantos/log_jira/log/log_service_jira_confluence_*.log -type f -mtime +10 -delete
find /home/magno/verifica_status/log/*.log -type f -mtime +10 -delete

##Gera somente um arquivo de log e adiciona log sem apagar anterior
DTHR=`date +%F`
exec >> /home/magno/verifica_status/log/log_service_jira_confluence_$DTHR.log

#Verifica status do servico jira
PROCESSO1='atlassian/jira'
jira_status=`ps ax | grep $PROCESSO1 | grep -v grep| wc -l`
#echo "${jira_status}"

DTHR=`date +%F-%T`
echo $DTHR

if [ $jira_status -eq 0 ]
then
	# SE O NUMERO DO PROCESSO FOR 0(ZERO), INICIA O SERVICO
	echo ""
	echo "================================================================================="
	echo ""
	DTHR=`date +%F-%T`
	echo $DTHR" - Servico Jira está parado."
	echo $DTHR" - Iniciando Jira."

	sudo /etc/init.d/jira start

	#Verifica e exibe status do serviço
	jira_status=`ps ax | grep $PROCESSO1 | grep -v grep| wc -l`
	echo "jira_status: ${jira_status}"
	echo ""

	echo "================================================================================="
	echo ""
fi


#Verifica status do servico confluence
PROCESSO2='atlassian/confluence'
confluence_status=`ps ax | grep $PROCESSO2 | grep -v grep| wc -l`
#echo "${confluence_status}"

if [ $confluence_status -eq 0 ]
then
	# SE O NUMERO DO PROCESSO FOR 0(ZERO), INICIA O SERVICO

	echo "================================================================================="
	echo ""
	DTHR=`date +%F-%T`
	echo $DTHR" - Servico confluence está parado."
	echo $DTHR" - Iniciando confluence."

	sudo /etc/init.d/confluence start

	#Verifica e exibe status do serviço
	confluence_status=`ps ax | grep $PROCESSO2 | grep -v grep| wc -l`
	echo "confluence_status: ${confluence_status}"
	echo ""

	echo "================================================================================="
	echo ""
fi

##echo "jira_status: ${jira_status}"
##echo "confluence_status: ${confluence_status}"
