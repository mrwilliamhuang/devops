pipeline {
    agent any
    
    environment {
        // 从 config.sh 加载环境变量
        CONFIG = "${SCRIPT_DIR}/config.sh"
    }
    
    parameters {
        choice(name: 'PROJECT', choices: ['mfsapi', 'mfsweb'], description: '选择要部署的项目')
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "初始化构建环境"
                    // 设置脚本目录
                    env.SCRIPT_DIR = "${SCRIPT_DIR}"
                }
            }
        }
        
        stage('Build') {
            steps {
                echo "Building ${params.PROJECT}..."
                // 这里可以添加构建步骤，如编译、测试等
            }
        }
        
        stage('Deploy') {
            steps {
                echo "Deploying ${params.PROJECT}..."
                sh '${SCRIPT_DIR}/deploy.sh ${params.PROJECT}'
            }
        }
        
        stage('Post-Deploy') {
            steps {
                echo "构建和部署完成: ${params.PROJECT}"
                // 这里可以添加部署后的操作，如通知、清理等
            }
        }
    }
}