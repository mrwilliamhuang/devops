# 部署指南

## 项目部署结构

- `~/production/mfsapi`: 从 `~/repo/mfsapi` 部署
- `~/production/mfsweb`: 从 `~/repo/mfsweb` 部署

## Jenkins配置

### Jenkins任务管理

支持通过脚本或Jenkins界面创建和管理任务。所有任务配置都集中管理在config.sh中。

#### 通过脚本创建任务

使用jenkins.sh脚本创建Jenkins任务：

```bash
# 创建deploy-api任务（用于mfsapi项目）
./jenkins.sh create-job mfsapi

# 创建deploy-web任务（用于mfsweb项目）
./jenkins.sh create-job mfsweb
```

#### 手动创建任务

也可以在Jenkins界面中手动创建任务，注意配置以下内容：

1. **deploy-api** (用于mfsapi项目)
   - 关联 `mfsapi` 项目的仓库
   - 使用 `../devops/Jenkinsfile` 作为流水线定义（相对于仓库根目录）
   - 配置参数化构建，选择 `PROJECT=mfsapi`

2. **deploy-web** (用于mfsweb项目)
   - 关联 `mfsweb` 项目的仓库
   - 使用 `../devops/Jenkinsfile` 作为流水线定义（相对于仓库根目录）
   - 配置参数化构建，选择 `PROJECT=mfsweb`

### 构建触发方式

支持多种方式触发构建：

1. 在Jenkins界面中手动点击 "Build Now"
2. 使用命令行触发（需要Jenkins CLI配置）
3. 使用以下命令通过API触发构建：

```bash
# 触发 mfsapi 构建
./jenkins.sh trigger mfsapi

# 触发 mfsweb 构建
./jenkins.sh trigger mfsweb
```

### Jenkinsfile管理

现在使用统一的Jenkinsfile管理所有项目的构建流程，位于：
`~/repo/devops/Jenkinsfile`

该文件支持参数化构建，可以通过参数选择部署哪个项目（mfsapi 或 mfsweb）。

### Jenkins脚本说明

Jenkins相关脚本已优化为简洁的模块化结构：

- **[jenkins.sh](file:///home/william/repo/devops/jenkins.sh)**：入口脚本（极简，仅5行）
- **[jenkins-main.sh](file:///home/william/repo/devops/jenkins-main.sh)**：主控制器（<30行）
- **[jenkins-common.sh](file:///home/william/repo/devops/jenkins-common.sh)**：公共函数和配置加载
- **[jenkins-create-job.sh](file:///home/william/repo/devops/jenkins-create-job.sh)**：创建Jenkins任务的功能
- **[jenkins-trigger.sh](file:///home/william/repo/devops/jenkins-trigger.sh)**：触发Jenkins构建的功能n
### 优化后的脚本统计

| 文件 | 行数 | 说明 |
|------|------|------|
| [jenkins.sh](file:///home/william/repo/devops/jenkins.sh) | 5行 | 入口脚本，仅做跳转 |
| [jenkins-main.sh](file:///home/william/repo/devops/jenkins-main.sh) | 25行 | 主控制器，处理命令行参数 |
| [jenkins-common.sh](file:///home/william/repo/devops/jenkins-common.sh) | 18行 | 公共函数和配置加载 |
| [jenkins-create-job.sh](file:///home/william/repo/devops/jenkins-create-job.sh) | 36行 | 创建Jenkins任务的功能 |
| [jenkins-trigger.sh](file:///home/william/repo/devops/jenkins-trigger.sh) | 27行 | 触发Jenkins构建的功能 |

### 脚本结构说明

```
jenkins.sh (5行) ----------------------> jenkins-main.sh (<30行)
                                          |             
                                          |             
                                          ↓             ↓
                                  jenkins-common.sh  jenkins-create-job.sh
                                                        ↑
                                                jenkins-trigger.sh
```

这种结构保持了代码的可维护性，同时将入口脚本压缩到极简状态。

# Jenkins 自动化管理脚本

本项目包含用于 Jenkins 自动化管理的脚本工具，能够重复生成任务并执行任务，使用 Jenkins CLI 实现。

## 部署结构

- `~/production/mfsapi`: 从 `~/repo/mfsapi` 部署
- `~/production/mfsweb`: 从 `~/repo/mfsweb` 部署

## 脚本说明

- `simple-jenkins-job.sh` - 创建最简单的 Jenkins 任务
- `jenkins.sh` - 入口脚本，处理命令行参数和核心流程
- `env-setup.sh` - 环境设置相关函数
- `cli-utils.sh` - Jenkins CLI 相关的通用函数
- `job-operations.sh` - 任务操作相关函数（创建任务、触发构建）

## 使用方法

### 创建最简单的 Jenkins 任务
```
./simple-jenkins-job.sh <项目名>
```

### 基本用法
```
./jenkins.sh <命令> [参数]
```

### 命令列表

| 命令        | 描述                  | 示例                  |
|-------------|-----------------------|-----------------------|
| create-job  | 创建 Jenkins 部署任务 | ./jenkins.sh create-job mfsapi |
| trigger     | 触发项目构建          | ./jenkins.sh trigger mfsweb    |
| version     | 显示 Jenkins 版本     | ./jenkins.sh version          |
| help        | 显示帮助信息          | ./jenkins.sh help             |

### 创建任务
```
./jenkins.sh create-job <项目名>
```

### 触发构建
```
./jenkins.sh trigger <项目名>
```

## 配置说明

在使用脚本前，请确保已正确配置以下文件：
- `config.sh` - 包含 Jenkins 连接信息和认证凭据
- `jenkins-cli.jar` - Jenkins CLI 工具

## 依赖说明

脚本依赖以下组件：
- Jenkins CLI 工具 (jenkins-cli.jar)
- Java 运行时环境
- Bash shell

## 注意事项

1. 确保 Jenkins 服务正在运行
2. 确保 Jenkins CLI 已正确配置
3. 确保具有足够的权限执行相关操作
4. 所有操作都将记录在 Jenkins 日志中

## 许可证

本项目采用 MIT 许可证。
