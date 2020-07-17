def DOCKER_IMAGE_BRANCH = ""
def GIT_COMMIT_HASH = ""

pipeline { 
    options {
        buildDiscarder(
            logRotator(
                artifactDaysToKeepStr: "",
                artifactNumToKeepStr: "",
                daysToKeepStr: "",
                numToKeepStr: "10"
            )
        )
        disableConcurrentBuilds()
    }

    agent any

    stages {

        stage("Prepare build image") {
            steps {
                sh "docker build -f Dockerfile.build . -t project-build:${DOCKER_IMAGE_BRANCH}"
            }
        }

        stage("Build project") {
            agent {
                docker {
                    image "project-build:${DOCKER_IMAGE_BRANCH}"
                    args "-v ${PWD}:/usr/src/app -w /usr/src/app"
                    reuseNode true
                    label "build-image"
                }
            }
            steps {
                sh "yarn install"
                sh "yarn test"
                sh "yarn build"
                sh "yarn start"

            }
        }

    post {
        always {
            step([$class: "WsCleanup"])
            cleanWs()
        }
    }

}
