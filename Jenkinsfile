pipeline {
    agent any
    parameters {
        choice(name: 'PROJECT', choices: ['mfsapi', 'mfsweb'], description: '选择要部署的项目')
    }
    stages {
        stage('验证工作目录') {
            steps {
                ws('/home/william/repo/devops') {
                    sh 'pwd' // 打印当前工作目录
                    sh 'ls -l' // 列出当前目录下的文件
                }
            }
        }
        stage('执行部署脚本') {
            steps {
                ws('/home/william/repo/devops') {
                    script {
                        if (params.PROJECT == 'mfsapi') {
                            // 执行 deploy_api.sh 脚本
                            sh './deploy_api.sh'
                        } else if (params.PROJECT == 'mfsweb') {
                            // 执行 deploy_web.sh 脚本
                            sh './deploy_web.sh'
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            echo "部署 ${params.PROJECT} 成功"
        }
        failure {
            echo "部署 ${params.PROJECT} 失败"
        }
    }
}


