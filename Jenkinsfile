// Powered by Infostretch 

timestamps {

node () {

	stage ('cicd-maven-docker-ecs01-pipeline - Checkout') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'jpriolo-github', url: 'https://github.com/jpriolo/cicd-maven-docker-ecs01-pipeline.git']]]) 
	}
	stage ('cicd-maven-docker-ecs01-pipeline - Build') {
 			// Shell build step
sh """ 
#!/bin/bash

### Install aws cli and pip
echo "Hello Joseph! "

if aws --version ; then
    echo "AWS CLI is installed. Exiting..."
else
    echo "AWS CLI IS NOT installed. Installing now..."
    apt install python-pip -y
    pip install --upgrade pip
    pip install awscli --upgrade --user
fi

DOCKER_LOGIN='aws ecr get-login --no-include-email --region us-west-2'
${DOCKER_LOGIN} 
 """
// Unable to convert a build step referring to "com.cloudbees.dockerpublish.DockerBuilder". Please verify and convert manually if required.		// Shell build step
sh """ 
#!/bin/bash
#Constants

REGION=us-west-2
REPOSITORY_NAME=test-repo
CLUSTER=test-cluster
FAMILY=test-repo
NAME=test-repo
SERVICE_NAME=${NAME}-service

#Store the repositoryUri as a variable
REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`

#Replace the build number and respository URI placeholders with the constants above
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" taskdef.json > ${NAME}-v_${BUILD_NUMBER}.json
#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json file://${WORKSPACE}/${NAME}-v_${BUILD_NUMBER}.json --region ${REGION}
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`
#Get latest revision
REVISION=`aws ecs describe-task-definition --task-definition ${NAME} --region ${REGION} | jq .taskDefinition.revision`

#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
  fi
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
else
  echo "entered new service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count 1 --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION}
fi 
 """ 
	}
}
}