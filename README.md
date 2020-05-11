# InstaBugChallenge

### Dockerfile:
```Dockerfile
FROM node:slim
RUN apt-get update &&  apt-get install -y \
    libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb git && \
    apt-get clean && \
    git clone https://github.com/dobromir-hristov/todo-app && \
    cd todo-app && \
    yarn install

WORKDIR /todo-app/

ENV PORT=4222
ENV CYPRESS_BASE_URL=http://localhost:4222
ENV DEBUG=cypress:*

ENTRYPOINT [ "yarn" ]
```

### Jenkinsfile:
```Groovy
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
```

---

### Issues:
1. Initially using `node:alpine` image resulted in e2e tests failure (missing xvfb and even aftar `apk add` xvfb still it gives errors)
Switching to `node:slim` instead and running e2e tests hangs indefinitely as shown 
![](https://github.com/theJaxon/InstaBugChallenge/blob/master/etc/CypressIssues.jpg)

![](https://github.com/theJaxon/InstaBugChallenge/blob/master/etc/e2e-testing-stuck.jpg)

so ~~e2e~~ was skipped!

2. copying build artifacts `/test-app/dist` most of the time it shows that there's a lock problem
ERROR  Error: EBUSY: resource busy or locked, rmdir '/todo-app/dist' and proceeds to remove the build directory

![](https://github.com/theJaxon/InstaBugChallenge/blob/master/etc/lock.jpg)
