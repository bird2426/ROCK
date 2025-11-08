<div align="center">

<img src="/img/favicon.ico" alt="ROCK Logo" class="rockImg"></img>

# ROCK: Reinforcement Open Construction Kit

<h4>🚀 强化学习环境构建工具包 🚀</h4>

<p>
  <a href="https://github.com/alibaba/ROCK/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg" alt="License"></img>
  </a>
  <a href="https://github.com/alibaba/ROCK/issues">
    <img src="https://img.shields.io/github/issues/alibaba/ROCK" alt="GitHub issues" />
  </a>
  <a href="https://github.com/alibaba/ROCK/stargazers">
    <img src="https://img.shields.io/github/stars/alibaba/ROCK?style=social" alt="Repo stars" />
  </a>
</p>

</div>

## 目录

- [ROCK: Reinforcement Open Construction Kit](#rock-reinforcement-open-construction-kit)
  - [目录](#目录)
  - [简介](#简介)
  - [🚀 核心特性](#-核心特性)
  - [📢 最新动态](#-最新动态)
  - [🚀 快速开始](#-快速开始)
    - [项目管理](#项目管理)
      - [注意事项](#注意事项)
    - [GEM协议环境使用](#gem协议环境使用)
    - [沙箱SDK使用](#沙箱sdk使用)
  - [🛠️ 系统架构](#️-系统架构)
    - [技术组件](#技术组件)
      - [SDK组件](#sdk组件)
      - [管理服务器](#管理服务器)
      - [支持读写分离架构](#支持读写分离架构)
    - [核心技术](#核心技术)
    - [GEM协议支持](#gem协议支持)
  - [📄 配置](#-配置)
    - [服务器配置](#服务器配置)
    - [开发环境配置](#开发环境配置)
  - [🤝 贡献](#-贡献)
    - [开发设置](#开发设置)
    - [报告问题](#报告问题)
    - [代码风格](#代码风格)
  - [📄 许可证](#-许可证)
  - [🙏 致谢](#-致谢)

## 简介

ROCK (Reinforcement Open Construction Kit) 是一个全面的沙箱环境管理框架，主要用于强化学习和AI开发环境。它提供了构建、运行和管理隔离容器化环境的工具，适用于开发、测试和研究场景。

ROCK采用客户端-服务器架构，使用Docker进行容器化，与现代开发工作流程无缝集成。ROCK不仅支持传统的沙箱管理功能，还兼容GEM协议, 为强化学习环境提供标准化接口。

---

## 🚀 核心特性

* **沙箱管理**: 创建和管理具有资源限制的隔离开发环境
* **SDK接口**: 简洁的Python SDK接口，支持所有核心操作
* **GEM协议兼容**: 兼容GEM环境接口，提供统一的强化学习环境访问
* **远程执行**: 通过HTTP API在远程沙箱环境中执行命令
* **自动清理**: 可配置时间后自动清理空闲沙箱
* **文件操作**: 沙箱环境间的文件上传和下载
* **并发测试**: 支持同时启动多个独立的沙箱环境进行并发测试
* **可选读写分离架构**: 支持可选的读写分离配置，提高系统性能和可扩展性

---

## 📢 最新动态

| 📣 更新内容 |
|:-----------|
| **[最新]** 🎉 ROCK 发布 |

---

## 🚀 快速开始

### 项目管理
ROCK项目使用`uv`进行依赖管理和虚拟环境管理，确保快速一致的环境配置：

```bash
# 克隆仓库
git clone https://github.com/alibaba/ROCK.git
cd ROCK

# 环境配置, ROCK推荐不使用系统Python创建虚拟环境, 而是使用托管的 Python
uv venv --python 3.11 --python-preference only-managed

# 使用uv安装依赖
uv sync --all-extras

# 激活虚拟环境
source .venv/bin/activate
```

具体示例可以参考[quickstart.md](quickstart.md)

### 注意事项

**重要**: ROCK 默认依赖 uv 工具进行环境管理。

1. **Python 环境配置**：为确保 ROCK 能正确挂载项目和虚拟环境及其依赖的 base Python 解释器，强烈推荐使用 uv 托管的 Python 环境来创建虚拟环境，而非使用系统 Python。这可以通过 `--python-preference only-managed` 参数实现。
当你不想使用uv来托管环境, 比如使用pip来安装时, 可以参考[installation.md](installation.md)安装, 以及参考[configuration.md](configuration.md)配置 UV 运行时环境启动。

2. **分布式环境一致性**：在分布式多机器环境中，请确保所有机器上 ROCK 和 uv 的 Python 配置使用相同的根 Python 解释器，以避免环境不一致问题。

3. **依赖管理**：使用 `uv` 命令安装所有依赖组，确保开发、测试和生产环境的一致性。

4. **OS 兼容性**：ROCK推荐在同一操作系统上管理环境, 比如在Linux系统上管理Linux镜像的环境, 但也支持跨操作系统级别的镜像管理, 例如在MacOS上启动Ubuntu镜像, 具体细节可以参考[quickstart.md](quickstart.md)中的MacOS启动一节

### GEM协议环境使用
ROCK完全兼容GEM协议，提供标准化的环境接口:

```python
import rock
import random
# 使用GEM标准接口创建环境
env_id = "game:Sokoban-v0-easy"
env = rock.make(env_id)

# 重置环境
observation, info = env.reset(seed=42)

while True:
# 交互式环境操作
    action = f"\\boxed{{{random.choice(['up', 'left', 'right', 'down'])}}}"
    observation, reward, terminated, truncated, info = env.step(action)

    if terminated or truncated:
        break

# 关闭环境
env.close()
```

### 沙箱SDK使用
```python
import asyncio

from rock.sdk.sandbox.client import Sandbox
from rock.sdk.sandbox.config import SandboxConfig
from rock.sdk.sandbox.request import CreateBashSessionRequest


async def run_sandbox():
    config = SandboxConfig(image="python:3.11", memory="8g", cpus=2.0)
    sandbox = Sandbox(config)

    await sandbox.start()
    await sandbox.create_session(CreateBashSessionRequest(session="bash-1"))
    result = await sandbox.arun(cmd="echo Hello Rock", session="bash-1")
    await sandbox.stop()


if __name__ == "__main__":
    asyncio.run(run_sandbox())

```

---

## 🛠️ 系统架构

### 技术组件

#### SDK组件
- **沙箱客户端**: 用于与远程沙箱环境交互的Python SDK
- **环境管理**: 构建和管理开发环境的工具

#### Admin管理服务器
管理沙箱编排的后端服务，支持可选的读写分离架构以提高性能和可扩展性：
- **写集群**: 处理沙箱创建/销毁等写操作
- **读集群**: （可选）处理现有沙箱的执行请求等读操作
- **API端点**: 沙箱管理的RESTful API

#### 支持读写分离架构
ROCK支持可选的读写分离架构，可以将不同类型的操作路由到专门的服务器集群以提高性能：

**写集群职责**：
- 沙箱环境的创建和销毁
- 其他修改系统状态的操作

**读集群职责**（可选）：
- 沙箱状态查询
- 命令执行
- 文件上传/下载
- 会话管理操作

读集群的设计目的是降低Ray的压力，可以直接管理到沙箱而无需再经过一次actor，从而提高系统的整体性能和响应速度。

默认情况下，ROCK使用单一集群处理所有操作。当配置了读写分离时，系统会将读操作和写操作分别路由到不同的集群，以提高性能和可扩展性。

### 核心技术
- **容器管理**: 使用Docker SDK进行容器编排
- **Web框架**: 使用FastAPI和uvicorn提供管理服务
- **分布式计算**: 使用Ray进行分布式任务处理
- **并发支持**: 支持同时启动多个独立的沙箱环境进行并发测试，充分利用系统资源

### GEM协议支持
ROCK兼容GEM协议，提供以下标准接口：
- `make(env_id)`: 创建环境实例
- `reset(seed)`: 重置环境状态
- `step(action)`: 执行动作并返回结果

GEM环境遵循标准的返回格式：
```python
# reset() 返回
observation, info = env.reset()

# step() 返回
observation, reward, terminated, truncated, info = env.step(action)
```

---

## 📄 配置


### 服务器配置
```bash
# 激活虚拟环境
source .venv/bin/activate

# 启动 Rock 服务，本地启动
admin --env local
```

> **服务信息**：ROCK Local Admin 服务默认运行在 `http://127.0.0.1:8080`。
额外配置信息如log, Rocklet服务启动方式可以参考[configuration.md](configuration.md)

### 开发环境配置
```bash
# 使用 uv 同步依赖
uv sync --all-extras --all-groups

# 在虚拟环境中运行
source .venv/bin/activate

# 运行测试
uv run pytest tests
```
---

## 🤝 贡献

我们欢迎社区的贡献！以下是参与方式：

### 开发设置
1. Fork仓库
2. 创建功能分支
3. 进行修改
4. 如适用，请添加测试
5. 提交拉取请求

### 报告问题
请使用GitHub问题跟踪器报告bug或建议功能。

### 代码风格
遵循现有的代码风格和约定。提交拉取请求前请运行测试。

---

## 📄 许可证

ROCK在Apache许可证（版本2.0）下分发。该产品包含其他开源许可证下的各种第三方组件。

---

## 🙏 致谢

ROCK由阿里巴巴集团开发。我们项目的rocklet组件主要基于SWE-ReX，并针对我们的特定用例进行了重大修改和增强。

重点感谢:

* [SWE-agent/SWE-ReX](https://github.com/SWE-agent/SWE-ReX)

---

<div align="center">
欢迎社区贡献！🤝
</div>