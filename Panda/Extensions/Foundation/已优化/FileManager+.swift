import UIKit

// MARK: - 静态方法
public extension FileManager {
    /// 判断路径是否存在
    /// - Parameter path: 路径
    /// - Returns: 是否存在
    static func pd_isExists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    /// 获取当前路径的上一级路径
    /// - Parameter fullPath: 完整路径
    /// - Returns: 上一级路径
    static func pd_previousPath(_ fullPath: String) -> String {
        return fullPath.pd_nsString().deletingLastPathComponent
    }

    /// 判断路径是否可读
    /// - Parameter path: 路径
    /// - Returns: 是否可读
    static func pd_isReadable(_ path: String) -> Bool {
        return FileManager.default.isReadableFile(atPath: path)
    }

    /// 判断路径是否可写
    /// - Parameter path: 路径
    /// - Returns: 是否可写
    static func pd_isWritable(_ path: String) -> Bool {
        return FileManager.default.isWritableFile(atPath: path)
    }

    /// 判断路径是否可执行
    /// - Parameter path: 路径
    /// - Returns: 是否可执行
    static func pd_isExecutable(_ path: String) -> Bool {
        return FileManager.default.isExecutableFile(atPath: path)
    }

    /// 判断路径是否可删除
    /// - Parameter path: 路径
    /// - Returns: 是否可删除
    static func pd_isDeletable(_ path: String) -> Bool {
        return FileManager.default.isDeletableFile(atPath: path)
    }

    /// 获取路径的扩展名
    /// - Parameter path: 路径
    /// - Returns: 扩展名
    static func pd_pathExtension(_ path: String) -> String {
        return path.pd_nsString().pathExtension
    }

    /// 获取文件名称
    /// - Parameters:
    ///   - path: 路径
    ///   - pathExtension: 是否获取扩展名
    /// - Returns: 文件名称
    static func pd_fileName(_ path: String, suffix pathExtension: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard pathExtension else { return (fileName as NSString).deletingPathExtension }
        return fileName
    }

    /// 获取指定路径下的所有子内容(不递归)
    /// - Parameter path: 路径
    /// - Returns: 内容数组
    static func pd_shallowSearchAllFiles(_ path: String) -> [String] {
        guard let result = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            return []
        }
        return result
    }

    /// 获取路径下的所有内容(递归)
    /// - Parameter path: 路径
    /// - Returns: 内容数组
    static func pd_allFiles(_ path: String) -> [String] {
        guard self.pd_isExists(path),
              let subPaths = FileManager.default.subpaths(atPath: path)
        else {
            return []
        }
        return subPaths
    }

    /// 遍历路径下的所有内容(递归)
    /// - Parameter path: 路径
    /// - Returns: 结果数组
    static func pd_deepSearchAllFiles(_ path: String) -> [Any]? {
        guard self.pd_isExists(path),
              let contents = FileManager.default.enumerator(atPath: path)
        else {
            return nil
        }
        return contents.allObjects
    }

    /// 获取`path`所指`文件`或`文件夹`的属性列表
    /// - Parameter path:路径
    /// - Returns:属性列表
    static func pd_attributeList(_ path: String) -> [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            return nil
        }
    }

    /// 计算路径下的存储大小(单位`字节`)
    /// - Parameter path: 路径
    /// - Returns: 存储大小
    static func pd_fileSize(_ path: String) -> UInt64 {
        guard self.pd_isExists(path) else { return 0 }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path),
              let sizeValue = attributes[FileAttributeKey.size] as? UInt64
        else {
            return 0
        }
        return sizeValue
    }

    /// 计算路径下的存储大小(格式化表示)
    /// - Parameter path: 路径
    /// - Returns: 格式化表示字符串
    static func pd_folderSize(_ path: String) -> String {
        if path.count == 0, !FileManager.default.fileExists(atPath: path) {
            return "0KB"
        }

        var fileSize: UInt64 = 0
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            for file in files {
                let path = path + "/\(file)"
                fileSize += self.pd_fileSize(path)
            }
        } catch {
            fileSize += self.pd_fileSize(path)
        }
        return fileSize.pd_storeUnit()
    }

    /// 判断两个路径所指向(文件/文件夹)是否一致
    /// - Parameters:
    ///   - path1: 路径1
    ///   - path2: 路径2
    /// - Returns: 是否一致
    static func pd_isEqual(path1: String, path2: String) -> Bool {
        guard self.pd_isExists(path1), self.pd_isExists(path2) else { return false }
        return FileManager.default.contentsEqual(atPath: path1, andPath: path2)
    }

    /// 创建文件夹
    /// - Parameter path: 完整路径
    /// - Returns: 创建结果
    @discardableResult
    static func pd_createFolder(_ path: String) -> (isOk: Bool, message: String) {
        if self.pd_isExists(path) { return (true, "文件已存在!") }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return (true, "创建成功!")
        } catch {
            return (false, "创建失败")
        }
    }

    /// 删除文件夹
    /// - Parameter path: 路径
    /// - Returns: 删除结果
    @discardableResult
    static func pd_removeFolder(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else { return (true, "文件夹不存在!") }
        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "删除成功!")
        } catch _ {
            return (false, "删除失败!")
        }
    }

    /// 创建文件
    /// - Parameter path: 路径
    /// - Returns: 创建结果
    @discardableResult
    static func pd_createFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else {
            let ok = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            return (ok, ok ? "创建成功!" : "创建失败!")
        }
        return (true, "文件已存在!")
    }

    /// 删除文件
    /// - Parameter path: 路径
    /// - Returns: 删除结果
    @discardableResult
    static func pd_removeFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else { return (true, "文件不存在!") }

        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "删除文件成功!")
        } catch {
            return (false, "删除文件失败!")
        }
    }

    /// 追加字符串到文件末尾
    ///
    /// - Note: `file`可以是 `Path`或者`URL`
    /// - Parameters:
    ///   - string: 要添加的内容
    ///   - address: 文件路径
    /// - Returns: 是否追加成功
    static func pd_appendStringToEnd(_ string: String, to file: Any) -> Bool {
        do {
            var fileURL: URL?
            if let url = file as? URL {
                fileURL = url
            } else if let path = file as? String {
                fileURL = path.pd_url()
            }

            guard let fileURL else { return false }

            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let content = "\n" + string

            fileHandle.seekToEndOfFile()
            fileHandle.write(content.pd_data()!)

            return true
        } catch let error as NSError {
            print("failed to append:\(error)")
            return false
        }
    }

    /// 在文件中追加`Data`数据
    /// - Parameters:
    ///   - data: 要写入的数据
    ///   - path: 文件路径
    /// - Returns: 写入结果
    @discardableResult
    static func pd_writeData(_ data: Data?, to path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(self.pd_previousPath(path)) else { return (false, "文件路径不存在!") }
        guard let data else { return (false, "写入数据不能为空!") }
        guard let url = path.pd_url(), path.pd_isValidUrl() else { return (false, "写入路径错误!") }

        do {
            try data.write(to: url, options: .atomic)
            return (true, "写入数据成功!")
        } catch {
            return (false, "写入数据失败!")
        }
    }

    /// 读取文件内容
    /// - Parameter path: 文件路径
    /// - Returns: 内容字符串
    @discardableResult
    static func pd_readFile(_ path: String) -> String? {
        guard self.pd_isExists(path) else { return nil }
        let data = FileManager.default.contents(atPath: path)
        return String(data: data!, encoding: String.Encoding.utf8)
    }

    /// 以`Data`方式读取文件内容
    /// - Parameter path: 文件路径
    /// - Returns: 读取结果
    @discardableResult
    static func pd_readData(from path: String) -> (isOk: Bool, data: Data?, error: String) {
        guard self.pd_isExists(path),
              let readHandler = FileHandle(forReadingAtPath: path)
        else {
            return (false, nil, "文件路径不存在!")
        }

        let data = readHandler.readDataToEndOfFile()
        if data.count == 0 { return (false, nil, "读取文件失败!") }
        return (true, data, "")
    }

    /// 拷贝文件或者文件夹
    /// - Parameters:
    ///   - fromPath: 来源路径
    ///   - toPath: 目标路径
    ///   - isFile: 是否是文件
    ///   - isCover: 是否覆盖
    /// - Returns: 拷贝结果
    @discardableResult
    static func pd_copyItem(
        from fromPath: String,
        to toPath: String,
        isFile: Bool = true,
        isCover: Bool = true
    ) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(fromPath) else { return (false, "文件路径不存在!") }

        if !self.pd_isExists(self.pd_previousPath(toPath)),
           isFile
           ? !self.pd_createFile(self.pd_previousPath(toPath)).isOk
           : !self.pd_createFolder(toPath).isOk
        {
            return (false, "要拷贝到的路径不存在!")
        }

        if isCover, self.pd_isExists(toPath) {
            do {
                try FileManager.default.removeItem(atPath: toPath)
            } catch {
                return (false, "拷贝失败!")
            }
        }

        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "拷贝失败!")
        }
        return (true, "拷贝成功!")
    }

    /// 移动文件或者文件夹
    /// - Parameters:
    ///   - fromPath: 来源路径
    ///   - toPath: 目标路径
    ///   - isFile: 是否是文件
    ///   - isCover: 是否覆盖
    /// - Returns: 移动结果
    @discardableResult
    static func pd_moveItem(
        from fromPath: String,
        to toPath: String,
        isFile: Bool = true,
        isCover: Bool = true
    ) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(fromPath) else { return (false, "要移动的文件不存在!") }

        if !self.pd_isExists(self.pd_previousPath(toPath)),
           isFile
           ? !self.pd_createFile(toPath).isOk
           : !self.pd_createFolder(toPath).isOk
        {
            return (false, "目标文件夹不存在!")
        }

        if isCover, self.pd_isExists(toPath) {
            do {
                try FileManager.default.removeItem(atPath: toPath)
            } catch {
                return (false, "移动失败!")
            }
        }

        do {
            try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "移动失败!")
        }
        return (true, "移动成功!")
    }
}
