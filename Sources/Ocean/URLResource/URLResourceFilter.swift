//
//  URLResourceFilter.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/06
//  
//

import Foundation
import UniformTypeIdentifiers
import OceanMacro

@URLResourceFilter
public extension [URL] {
    
    enum URLResourceFilter {
        
        case name(String)
        case localizedName(String)
        case isRegularFile(Bool)
        case isDirectory(Bool)
        case isSymbolicLink(Bool)
        case isVolume(Bool)
        case isPackage(Bool)
        case isApplication(Bool)
        #if os(macOS)
        case applicationIsScriptable(Bool)
        #endif
        case isSystemImmutable(Bool)
        case isUserImmutable(Bool)
        case isHidden(Bool)
        case hasHiddenExtension(Bool)
        case creationDate(Date)
        case contentAccessDate(Date)
        case contentModificationDate(Date)
        case attributeModificationDate(Date)
        case linkCount(Int)
        case parentDirectory(URL, key: String = ".parentDirectoryURLKey")
        case volumeURL(URL, key: String = ".volumeURLKey", path: String = #"\.volume"#)
        
        @available(macOS, deprecated: 100000, renamed: "filter(byContentType:)")
        case typeIdentifier(String)
        
        case contentType(UTType)
        case localizedTypeDescription(String)
        case labelNumber(Int)
        // case labelColor(NSColor)
        case localizedLabel(String)
        // case effectiveIcon(NSImage)
        // case customIcon(NSImage)
        case fileResourceIdentifier(any NSCopying & NSSecureCoding & NSObjectProtocol)
        case volumeIdentifier(any NSCopying & NSSecureCoding & NSObjectProtocol)
        case preferredIOBlockSize(Int)
        case isReadable(Bool)
        case isWritable(Bool)
        case isExecutable(Bool)
        case fileSecurity(NSFileSecurity)
        case isExcludedFromBackup(Bool)
        #if os(macOS)
        case tagNames([String])
        #endif
        case path(FilePathConvertible)
        case canonicalPath(FilePathConvertible)
        case isMountTrigger(Bool)
        case generationIdentifier(any NSCopying & NSSecureCoding & NSObjectProtocol)
        case documentIdentifier(Int)
        case addedToDirectoryDate(Date)
        #if os(macOS)
        case quarantineProperties([String : Any])
        #endif
        case fileResourceType(URLFileResourceType)
        
        case fileIdentifier(UInt64, available: String = "macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *")
        case fileContentIdentifier(Int64)
        case mayShareFileContent(Bool)
        case mayHaveExtendedAttributes(Bool)
        case isPurgeable(Bool)
        case isSparse(Bool)
        case fileSize(Int)
        case fileAllocatedSize(Int)
        case totalFileSize(Int)
        case fileProtection(URLFileProtection)
        case directoryEntryCount(Int, available: String = "macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *")
        case volumeLocalizedFormatDescription(String)
        case volumeTotalCapacity(Int)
        case volumeAvailableCapacity(Int)
        case volumeAvailableCapacityForImportantUsage(Int64)
        case volumeAvailableCapacityForOpportunisticUsage(Int64)
        case volumeResourceCount(Int)
        case volumeSupportsPersistentIDs(Bool)
        case volumeSupportsSymbolicLinks(Bool)
        case volumeSupportsHardLinks(Bool)
        case volumeSupportsJournaling(Bool)
        case volumeIsJournaling(Bool)
        case volumeSupportsSparseFiles(Bool)
        case volumeSupportsZeroRuns(Bool)
        case volumeSupportsCaseSensitiveNames(Bool)
        case volumeSupportsCasePreservedNames(Bool)
        case volumeSupportsRootDirectoryDates(Bool)
        case volumeSupportsVolumeSizes(Bool)
        case volumeSupportsRenaming(Bool)
        case volumeSupportsAdvisoryFileLocking(Bool)
        case volumeSupportsExtendedSecurity(Bool)
        case volumeIsBrowsable(Bool)
        case volumeMaximumFileSize(Int)
        case volumeIsEjectable(Bool)
        case volumeIsRemovable(Bool)
        case volumeIsInternal(Bool)
        case volumeIsAutomounted(Bool)
        case volumeIsLocal(Bool)
        case volumeIsReadOnly(Bool)
        case volumeCreationDate(Date)
        case volumeURLForRemounting(URL)
        case volumeUUIDString(String)
        case volumeName(String)
        case volumeLocalizedName(String)
        case volumeIsEncrypted(Bool)
        case volumeIsRootFileSystem(Bool)
        case volumeSupportsCompression(Bool)
        case volumeSupportsFileCloning(Bool)
        case volumeSupportsSwapRenaming(Bool)
        case volumeSupportsExclusiveRenaming(Bool)
        case volumeSupportsImmutableFiles(Bool)
        case volumeSupportsAccessPermissions(Bool)
        case volumeTypeName(String, available: String = "macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *")
        case volumeSubtype(Int, available: String = "macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *")
        case volumeMountFromLocation(String, available: String = "macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *")
        case isUbiquitousItem(Bool)
        case ubiquitousItemHasUnresolvedConflicts(Bool)
        case ubiquitousItemIsDownloading(Bool)
        case ubiquitousItemIsUploaded(Bool)
        case ubiquitousItemIsUploading(Bool)
        case ubiquitousItemDownloadingStatus(URLUbiquitousItemDownloadingStatus)
        case ubiquitousItemDownloadingError(NSError)
        case ubiquitousItemUploadingError(NSError)
        case ubiquitousItemDownloadRequested(Bool)
        case ubiquitousItemContainerDisplayName(String)
        case ubiquitousItemIsExcludedFromSync(Bool)
        case ubiquitousItemIsShared(Bool, available: [String] = ["tvOS, unavailable", "watchOS, unavailable"])
        case ubiquitousSharedItemCurrentUserRole(URLUbiquitousSharedItemRole, available: [String] = ["tvOS, unavailable", "watchOS, unavailable"])
        case ubiquitousSharedItemCurrentUserPermissions(URLUbiquitousSharedItemPermissions, available: [String] = ["tvOS, unavailable", "watchOS, unavailable"])
        case ubiquitousSharedItemOwnerNameComponents(PersonNameComponents)
        case totalFileAllocatedSize(Int)
        case isAliasFile(Bool)
    }
}
