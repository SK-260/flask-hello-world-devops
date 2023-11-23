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
                    .venv/bin/flake8 --format=pylint app.py test.py --exit-zero --output-file report.txt 
                '''
                recordIssues(tools: [flake8(pattern: 'report.txt')])
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
    }
}

