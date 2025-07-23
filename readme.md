1. 本项目涵盖 Jenkins 自动化管理与部署脚本，支持 mfsapi 和 mfsweb 两个项目的部署工作。
2. 脚本采用模块化设计，各脚本职责明确，例如 deploy_api.sh 负责 mfsapi 部署，deploy_web.sh 负责 mfsweb 部署。
3. 通过统一的 Jenkinsfile 进行参数化构建，可在 Jenkins 界面选择项目，还能使用 send_jenkinsfile.sh 脚本借助 REST API 从命令行触发部署任务。
4. 项目依赖 Bash shell，使用时需确保该工具存在。
5. 注重安全，给脚本设置 755 权限，同时做好输入验证和错误处理，保障部署流程稳定。