pipeline {
    agent any

    stages{
        stage("Clearing the Workspace"){
            steps{
                deleteDir()
            }
        }

        stage("Code Checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/SK-260/flask-hello-world-devops'
            }
        }

        stage("Installing Dependencies"){
            steps{
                sh '''#!/bin/bash
                    sudo apt install -y python3.11-venv
                    python3 -m venv .venv
                    source .venv/bin/activate
                    python3 -m pip install -r ./requirements.txt
                '''
            }
        }

        stage("Code Analysis"){
            steps{
                sh '''#!/bin/bash
                    .venv/bin/flake8 --format=pylint app.py test.py --exit-zero --output-file flak-report.xml 
                '''
                recordIssues(tools: [flake8(pattern: 'flak-report.xml')])
            }
        }

        stage("Junit Test"){
            steps{
                sh '''#!/bin/bash                    
                    .venv/bin/pytest test.py --junit-xml=report.xml
                '''
                junit skipPublishingChecks: true, testResults: 'report.xml'
            }
        }
        stage("Sonar Analysis"){
            environment{
                scannerHome = tool 'sonarscanner'
            }
            steps{ 
                withSonarQubeEnv(installationName:'sonarserver', credentialsId: 'sonarkey'){
                    sh '''${scannerHome}/bin/sonar-scanner -X -Dsonar.projectKey=flash-hello-world\
                        -Dsonar.projectName=flash-hello-world\
                        -Dsonar.projectVersion=1.0\
                        -Dsonar.sources=app.py\
                        -Dsonar.tests=test.py\
                        -Dsonar.python.xunit.reportPath=report.xml\
                        
                        '''
                }
            }
        }
    }
}



// -Dsonar.testExecutionReportPaths=flak-report.xml