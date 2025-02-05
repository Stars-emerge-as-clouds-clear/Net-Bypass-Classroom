# Windows 系统功能解除限制与进程终止工具

## 简介
本项目是一个基于 VBScript 的脚本工具，用于解除 Windows 系统中某些被限制的功能（如任务管理器、注册表工具、命令提示符等），并提供终止指定进程的功能。适用于需要快速恢复系统功能或终止特定进程的场景。

## 功能特性
- **解除系统功能限制**：通过修改注册表，解除任务管理器、注册表工具、命令提示符等的禁用状态。
- **进程终止功能**：允许用户输入进程名称，终止一个或多个指定进程。
- **用户交互友好**：通过输入框和消息框与用户进行交互，操作简单直观。

## 使用方法

### 区分版本
本软件有三个版本,分别为:`Net Bypass Classroom-en-re`、`Net Bypass Classroom-en`、`Net Bypass Classroom-zh`
1.Net Bypass Classroom-en-re(-re为Releases的缩写) 此版本无注释,全英文,适合直接使用的群体。
2.Net Bypass Classroom-en 此版本有全英文注释,全英文,适合母语为英文又需要查看原理的群体。
3.Net Bypass Classroom-zh 此版本有中文注释,对话为中文,适合母语为中文又需要查看原理的群体。

### 解除系统功能限制
运行脚本后，会自动解除以下注册表项的限制：
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun`

### 终止进程
运行脚本后，会弹出输入框，提示输入需要终止的进程名称（以空格分隔）。例如，输入 `notepad.exe calc.exe`，将终止记事本和计算器进程。

## 运行脚本
1. 将脚本保存为 `.vbs` 文件（例如：`UnbanAndKillProcesses.vbs`）。
2. 通过命令行执行：
   ```bash
   cscript UnbanAndKillProcesses.vbs

## 注意事项
- **管理员权限**：运行脚本时可能需要管理员权限，以确保对注册表和进程的修改生效。
- **谨慎操作**：终止进程可能会导致数据丢失或系统不稳定，请确保输入的进程名称正确且安全。

## 贡献指南
欢迎贡献代码或提出改进建议！请按照以下步骤操作：
1. Fork 本仓库。
2. 创建一个新分支：`git checkout -b feature/your-feature-branch`。
3. 提交您的更改：`git commit -m "Your commit message"`。
4. 提交 Pull Request。

## 许可证
本项目采用 MIT 许可证。详细信息请查看 [LICENSE](LICENSE) 文件。

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Windows Feature Unbanning and Process Killing Tool

## Overview
This project is a VBScript-based tool designed to unban restricted features in the Windows operating system (such as Task Manager, Registry Editor, Command Prompt, etc.) and terminate specified processes. It is useful for quickly restoring system functionality or terminating specific processes.

## Features
- **Unban System Features**: Modify the registry to unban restrictions on Task Manager, Registry Editor, Command Prompt, and more.
- **Process Termination**: Allow users to input process names to terminate one or multiple processes.
- **User-Friendly Interaction**: Interact with users through input boxes and message boxes for an intuitive experience.

## Usage

### Unban System Features
When the script runs, it will automatically unban the following registry keys:
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCMD`
- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRun`

### Terminate Processes
After running the script, an input box will prompt you to enter the names of processes to terminate (separated by spaces). For example, entering `notepad.exe calc.exe` will terminate the Notepad and Calculator processes.

## Notes
- **Administrator Privileges**: Running the script may require administrator privileges to ensure registry and process modifications take effect.
- **Caution**: Terminating processes may lead to data loss or system instability. Ensure the process names you input are correct and safe.

## Contribution Guidelines
We welcome contributions of code or suggestions for improvement! Please follow these steps:
1. Fork this repository.
2. Create a new branch: `git checkout -b feature/your-feature-branch`.
3. Commit your changes: `git commit -m "Your commit message"`.
4. Submit a Pull Request.

## License
This project is licensed under the MIT License. For details, see the [LICENSE](LICENSE) file.
