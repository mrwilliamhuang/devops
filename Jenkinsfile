pipeline {
    agent any
    parameters {
        choice(name: 'PROJECT', choices: ['mfsapi', 'mfsweb'], description: '选择要部署的项目')
    }
    stages {
        stage('执行部署脚本') {
            steps {
                script {
                    if (params.PROJECT == 'mfsapi') {
                        // 修正脚本名，执行 deploy_api.sh 脚本
                        sh './deploy_api.sh'
                    } else if (params.PROJECT == 'mfsweb') {
                        // 执行 deploy_web.sh 脚本
                        sh './deploy_web.sh'
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
