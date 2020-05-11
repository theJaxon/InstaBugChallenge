pipeline 
{
    agent any
    stages {
        stage('Unit tests') {
            steps {
               sh "docker build -t 'node-unit-test' . && docker run --rm  'node-unit-test' 'test:unit'" 
            }
        }

        stage('Linting') {
            steps {
               sh "docker build -t 'node-lint' . && docker run --rm  'node-lint' 'lint'" 
            }
        }

        // stage('e2e testing') {
        //     steps {
        //         sh "docker build -t 'node-e2e-test' . && docker run -p 4222:4222 --rm 'node-e2e-test' 'test:e2e'" 
        //     }
        // }

        stage('build the application') {
            steps {
                //sh "docker build -t 'node-build' . && docker create --name 'node-build' 'node-build' 'build'" 
                sh "docker build -t 'node-build' . && docker run -i -v /tmp/:/todo-app/dist/ --name 'node-build' 'node-build' 'build'" 
                sh "docker cp node-build:/todo-app/dist/ /tmp/"
                sh "docker stop 'node-build'"
                sh "docker rm 'node-build'"
            }
        }

        stage('serve the application') {
            steps {
                sh "docker build -t 'node-serve' . && docker run -p 4222:4222 'node-serve' 'serve'" 
            }
        }

        
    }
}