import UIKit

public extension FileManager {
    static func pd_isExists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    static func pd_previousPath(_ fullPath: String) -> String {
        return fullPath.pd_nsString().deletingLastPathComponent
    }

    static func pd_isReadable(_ path: String) -> Bool {
        return FileManager.default.isReadableFile(atPath: path)
    }

    static func pd_isWritable(_ path: String) -> Bool {
        return FileManager.default.isWritableFile(atPath: path)
    }

    static func pd_isExecutable(_ path: String) -> Bool {
        return FileManager.default.isExecutableFile(atPath: path)
    }

    static func pd_isDeletable(_ path: String) -> Bool {
        return FileManager.default.isDeletableFile(atPath: path)
    }

    static func pd_pathExtension(_ path: String) -> String {
        return path.pd_nsString().pathExtension
    }

    static func pd_fileName(_ path: String, suffix pathExtension: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard pathExtension else { return (fileName as NSString).deletingPathExtension }
        return fileName
    }

    static func pd_shallowSearchAllFiles(_ path: String) -> [String] {
        guard let result = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            return []
        }
        return result
    }

    static func pd_allFiles(_ path: String) -> [String] {
        guard self.pd_isExists(path),
              let subPaths = FileManager.default.subpaths(atPath: path)
        else {
            return []
        }
        return subPaths
    }

    static func pd_deepSearchAllFiles(_ path: String) -> [Any]? {
        guard self.pd_isExists(path),
              let contents = FileManager.default.enumerator(atPath: path)
        else {
            return nil
        }
        return contents.allObjects
    }

    static func pd_attributeList(_ path: String) -> [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            return nil
        }
    }

    static func pd_fileSize(_ path: String) -> UInt64 {
        guard self.pd_isExists(path) else { return 0 }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path),
              let sizeValue = attributes[FileAttributeKey.size] as? UInt64
        else {
            return 0
        }
        return sizeValue
    }

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

    static func pd_isEqual(path1: String, path2: String) -> Bool {
        guard self.pd_isExists(path1), self.pd_isExists(path2) else { return false }
        return FileManager.default.contentsEqual(atPath: path1, andPath: path2)
    }

    @discardableResult
    static func pd_createFolder(_ path: String) -> (isOk: Bool, message: String) {
        if self.pd_isExists(path) { return (true, "file already exists!") }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return (true, "create success!")
        } catch {
            return (false, "create success!")
        }
    }

    @discardableResult
    static func pd_removeFolder(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else { return (true, "file not exists!") }
        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "delete success!")
        } catch _ {
            return (false, "delete failed!")
        }
    }

    @discardableResult
    static func pd_createFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else {
            let ok = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            return (ok, ok ? "create success!" : "create failed!")
        }
        return (true, "file already exists!")
    }

    @discardableResult
    static func pd_removeFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(path) else { return (true, "file not exists!") }

        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "delete success!")
        } catch {
            return (false, "delete failed!")
        }
    }

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

    @discardableResult
    static func pd_writeData(_ data: Data?, to path: String) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(self.pd_previousPath(path)) else { return (false, "file not exists!") }
        guard let data else { return (false, "data is not empty!") }
        guard let url = path.pd_url(), path.pd_isValidUrl() else { return (false, "write path error!") }

        do {
            try data.write(to: url, options: .atomic)
            return (true, "write success!")
        } catch {
            return (false, "write failed!")
        }
    }

    @discardableResult
    static func pd_readFile(_ path: String) -> String? {
        guard self.pd_isExists(path) else { return nil }
        let data = FileManager.default.contents(atPath: path)
        return String(data: data!, encoding: String.Encoding.utf8)
    }

    @discardableResult
    static func pd_readData(from path: String) -> (isOk: Bool, data: Data?, error: String) {
        guard self.pd_isExists(path),
              let readHandler = FileHandle(forReadingAtPath: path)
        else {
            return (false, nil, "file not exists!")
        }

        let data = readHandler.readDataToEndOfFile()
        if data.count == 0 { return (false, nil, "read failed!") }
        return (true, data, "")
    }

    @discardableResult
    static func pd_copyItem(
        from fromPath: String,
        to toPath: String,
        isFile: Bool = true,
        isCover: Bool = true
    ) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(fromPath) else { return (false, "path not exists!") }

        if !self.pd_isExists(self.pd_previousPath(toPath)),
           isFile
           ? !self.pd_createFile(self.pd_previousPath(toPath)).isOk
           : !self.pd_createFolder(toPath).isOk
        {
            return (false, "path not exists!")
        }

        if isCover, self.pd_isExists(toPath) {
            do {
                try FileManager.default.removeItem(atPath: toPath)
            } catch {
                return (false, "copy failed!")
            }
        }

        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "copy failed!")
        }
        return (true, "copy success!")
    }

    @discardableResult
    static func pd_moveItem(
        from fromPath: String,
        to toPath: String,
        isFile: Bool = true,
        isCover: Bool = true
    ) -> (isOk: Bool, message: String) {
        guard self.pd_isExists(fromPath) else { return (false, "path not exists!") }

        if !self.pd_isExists(self.pd_previousPath(toPath)),
           isFile
           ? !self.pd_createFile(toPath).isOk
           : !self.pd_createFolder(toPath).isOk
        {
            return (false, "path not exists!")
        }

        if isCover, self.pd_isExists(toPath) {
            do {
                try FileManager.default.removeItem(atPath: toPath)
            } catch {
                return (false, "move failed!")
            }
        }

        do {
            try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "move failed!")
        }
        return (true, "move success!")
    }
}
