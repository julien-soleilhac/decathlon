package jc.tools.pub;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
import com.ibm.icu.text.SimpleDateFormat;
import com.wm.util.coder.JSONCoder;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigInteger;
import java.nio.file.CopyOption;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
// --- <<IS-END-IMPORTS>> ---

public final class file

{
	// ---( internal utility methods )---

	final static file _instance = new file();

	static file _newInstance() { return new file(); }

	static file _cast(Object o) { return (file)o; }

	// ---( server methods )---




	public static final void copy (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(copy)>> ---
		// @sigtype java 3.5
		// [i] field:0:required srcDir
		// [i] field:0:required srcName
		// [i] field:0:required tgtDir
		// [i] field:0:required tgtName
		// [i] field:0:optional overwrite {"true","false"}
		// [o] field:0:required tgtPath
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String srcDirectory = IDataUtil.getString( pipelineCursor, "srcDir");
		String src = IDataUtil.getString( pipelineCursor, "srcName");
		String tgtDirectory = IDataUtil.getString( pipelineCursor, "tgtDir");
		String tgt = IDataUtil.getString( pipelineCursor, "tgtName");
		String overwrite = IDataUtil.getString(pipelineCursor, "overwrite");
		
		pipelineCursor.destroy();
		
		// process
		
		try {
			
			if (!new File(tgtDirectory).exists());
				new File(tgtDirectory).mkdirs();
				
			if (tgt == null)
				tgt = src;
			
			if  (new File(srcDirectory, src).isDirectory())
				new DirCopier(FileSystems.getDefault().getPath(srcDirectory, src), FileSystems.getDefault().getPath(tgtDirectory, tgt)).copy(overwrite != null && overwrite.equalsIgnoreCase("true"));
			else if (overwrite != null && overwrite.equalsIgnoreCase("true"))
				Files.copy(FileSystems.getDefault().getPath(srcDirectory, src), FileSystems.getDefault().getPath(tgtDirectory, tgt), StandardCopyOption.REPLACE_EXISTING);
			else
				Files.copy(FileSystems.getDefault().getPath(srcDirectory, src), FileSystems.getDefault().getPath(tgtDirectory, tgt));
		} catch (IOException e) {
			throw new ServiceException(e);
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "tgtPath", new File(tgtDirectory, tgt).getPath());
		// --- <<IS-END>> ---

                
	}



	public static final void createFolder (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(createFolder)>> ---
		// @sigtype java 3.5
		// [i] field:0:required name
		// [i] field:0:optional force {"true","false"}
		// [o] field:0:required success {"done","failed","exists"}
		// [o] field:0:optional since
		// [o] field:0:optional isEmpty {"true","false"}
		IDataCursor c = pipeline.getCursor();
		String fname = IDataUtil.getString(c, "name");
		String force = IDataUtil.getString(c, "force");
		
		File dir = new File(fname);
		String success = "exists";
		long since = 0;
		boolean isEmpty = true;
		
		if (!dir.exists())
		{
			if (dir.mkdirs())
				success = "done";
			else
				success = "failed";
		} else if (force != null && force.equalsIgnoreCase("true")) {
			
			deleteDir(dir);
			
			if (dir.mkdirs())
				success = "done";
			else
				success = "failed";
		} else {
		
			since = (new Date().getTime()  - new Date(dir.lastModified()).getTime()) / 60000;
			isEmpty = dir.list().length == 0;
		}
		
		// pipeline out
		
		IDataUtil.put(c, "success", success);
		
		if (success.equals("exists")) {
			IDataUtil.put(c, "since", "" + since);
			IDataUtil.put(c, "isEmpty", "" + isEmpty);
		}
		c.destroy();
			
		// --- <<IS-END>> ---

                
	}



	public static final void deleteFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(deleteFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required fname
		// [o] field:0:required deleted {"true","false"}
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String	fname = IDataUtil.getString(pipelineCursor, "fname");
				
		// process
				
		boolean delete = new File(fname).delete();
				
		// pipeline out
				
		IDataUtil.put(pipelineCursor, "deleted", "" + delete);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void fileExists (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(fileExists)>> ---
		// @sigtype java 3.5
		// [i] field:0:required fname
		// [o] field:0:required exists {"true","false"}
		// [o] field:0:optional isDir
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String	fname = IDataUtil.getString(pipelineCursor, "fname");
		
		// process
		
		boolean exists = new File(fname).exists();
		boolean isDir = new File(fname).isDirectory();
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "exists", "" + exists);
		
		if (exists)
			IDataUtil.put(pipelineCursor, "isDir", "" + isDir);
		
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void getFileReference (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getFileReference)>> ---
		// @sigtype java 3.5
		// [i] field:0:required path
		// [i] field:0:required file
		// [o] object:0:required file
		
		// pipeline in
		IDataCursor pipelineCursor = pipeline.getCursor();
		String path = IDataUtil.getString(pipelineCursor, "path");
		String f = IDataUtil.getString(pipelineCursor, "file");
		
		// process
		
		File file;
		
		if (path != null)
			file = new File(path, f);
		else
			file = new File(f);
		
		if (!file.exists())
			throw new ServiceException("File '" + (path != null ? path + "/" + file : file) + "' does not exist!");
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "file", file);
		pipelineCursor.destroy();
		
			
		// --- <<IS-END>> ---

                
	}



	public static final void lastModifiedDateOfFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(lastModifiedDateOfFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required file
		// [o] field:0:required lastModifiedDate
		IDataCursor c = pipeline.getCursor();
		String file = IDataUtil.getString(c, "file");
		
		// process
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		String dateStr = sdf.format(new Date(new File(file).lastModified()));
		
		// pipeline out
		
		IDataUtil.put(c, "lastModifiedDate", dateStr);
		// --- <<IS-END>> ---

                
	}



	public static final void listFilesIncDirs (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(listFilesIncDirs)>> ---
		// @sigtype java 3.5
		// [i] field:0:required dir
		// [i] field:0:required filter
		// [o] field:1:required files
		// pipeline in
		IDataCursor c = pipeline.getCursor();
		String dir = IDataUtil.getString(c, "dir");
		String filter = IDataUtil.getString(c, "filter");
			
		// process
			
		List<String> files = listf(dir, filter);
		    
		// pipeline out
		
		if (files != null)
			IDataUtil.put(c, "files", files.toArray(new String[files.size()]));
		
		c.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void ls (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(ls)>> ---
		// @sigtype java 3.5
		// [i] field:0:required path
		// [i] field:0:optional filter
		// [o] field:1:required files
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String path = IDataUtil.getString(pipelineCursor, "path");
		String filter = IDataUtil.getString(pipelineCursor, "filter");
		
		// process
		
		File dir = new File(path);
		String[] files;
		
		if (dir.exists()) {
			if (dir.isDirectory())
				files = dir.list(new FilenameFilter() {
					
					@Override
					public boolean accept(File file, String filename) {
						
						return !filename.startsWith(".") && (filter == null || filename.contains(filter));
					}
				});
			else
				throw new ServiceException("path is not a directory:" + path);
		} else {
			throw new ServiceException("Directory does not exist:" + path);
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "files", files);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void moveFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(moveFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required srcFile
		// [i] field:0:required destDir
		// [i] field:0:optional appendTimeStamp {"false","true"}
		// [i] field:0:optional pattern
		// [o] field:0:required destFile
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String srcFile = IDataUtil.getString(pipelineCursor, "srcFile");
		String destDir = IDataUtil.getString(pipelineCursor, "destDir");
		String appendTimeStamp = IDataUtil.getString( pipelineCursor, "appendTimeStamp");
		String pattern = IDataUtil.getString(pipelineCursor, "pattern");
		
		// process
		
		if (destDir == null)
			destDir = new File(srcFile).getParent();
		
		boolean append = false;
		Path src = FileSystems.getDefault().getPath(srcFile);
		Path dest = FileSystems.getDefault().getPath(destDir, src.getName(src.getNameCount()-1).toFile().getName());
		
		try {
			append = Boolean.parseBoolean(appendTimeStamp);
		} catch (Exception e) {}
		
		if (append) {
			SimpleDateFormat fmt = new SimpleDateFormat(pattern != null ? pattern : "MMddyy");
			
			dest = FileSystems.getDefault().getPath("./", dest.toFile().getPath() +  "." + fmt.format(new Date()));
		}
		
		try {
			Files.move(src, dest, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			throw new ServiceException(e);
		}
		
		// pipeline out
		
		 IDataUtil.put(pipelineCursor, "destFile", dest.toFile().getPath());
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void readFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(readFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required fname
		// [i] field:0:required loadAs {"bytes","string","stream"}
		// [i] field:0:optional ignoreError {"false","true"}
		// [o] object:0:optional bytes
		// [o] field:0:optional string
		// [o] object:0:optional stream
		IDataCursor c = pipeline.getCursor();
		String fname = IDataUtil.getString(c, "fname");
		String loadas = IDataUtil.getString(c, "loadAs");
		String ignoreError = IDataUtil.getString(c, "ignoreError");
		
		if (fname == null)
			throw new ServiceException("provide file name please");
		
		// process
		
		byte[] data = null;
		InputStream in = null;
		
		try {
			if (loadas != null && loadas.equalsIgnoreCase("stream"))
				in = new FileInputStream(new File(fname));
			else
				data = Files.readAllBytes(Paths.get(fname));
		} catch (NoSuchFileException e ) {
			if (ignoreError == null || !ignoreError.equalsIgnoreCase("true"))
				throw new ServiceException(e);
		} catch (IOException e) {
			
			throw new ServiceException(e);
		}
		
		// pipeline out
		
		if (data != null) {
			
			if (loadas != null && loadas.equalsIgnoreCase("string"))
				IDataUtil.put(c, "string", new String(data));
			else
				IDataUtil.put(c, "bytes", data);
			c.destroy();
		} else {
			IDataUtil.put(c, "stream", in);
		}
		// --- <<IS-END>> ---

                
	}



	public static final void readJsonList (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(readJsonList)>> ---
		// @sigtype java 3.5
		// [i] field:0:required fname
		// [o] record:1:required rows
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String fname = IDataUtil.getString(pipelineCursor, "fname");
		
		// process
		
		List<IData>	rows = new ArrayList<IData>();
		
		try {
			List<String> lines = Files.readAllLines(FileSystems.getDefault().getPath(fname));
			
			for (int i = 0; i < lines.size(); i++) {
			
				Values v = new JSONCoder().decodeFromBytes(lines.get(i).getBytes());
				
				rows.add(makeValuesIntoIData(v));
			}
			
		} catch (IOException e) {
			throw new ServiceException(e);
		}
		
		// pipeline out
		
		IDataUtil.put( pipelineCursor, "rows", rows.toArray(new IData[rows.size()]));
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void unzip (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(unzip)>> ---
		// @sigtype java 3.5
		// [i] field:0:required zipfile
		// [i] field:0:required destDir
		IDataCursor c = pipeline.getCursor();
		String zipfile = IDataUtil.getString(c, "zipfile");
		String destDir = IDataUtil.getString(c, "destDir");
		
		c.destroy();
		
		new UnzipFiles().unzip(zipfile, destDir);
			
		// --- <<IS-END>> ---

                
	}



	public static final void writeFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(writeFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required fileName
		// [i] record:0:required data
		// [i] - field:0:optional string
		// [i] - object:0:optional bytes
		// [i] - object:0:optional stream
		// [o] field:0:required fileNameOnly
		// pipeline in
		
				IDataCursor pipelineCursor = pipeline.getCursor();
				String fileName = IDataUtil.getString(pipelineCursor, "fileName");
				IData data = IDataUtil.getIData( pipelineCursor, "data");
				IDataCursor dataCursor = data.getCursor();
				String	string = IDataUtil.getString( dataCursor, "string");
				byte[] bytes = (byte[]) IDataUtil.get(dataCursor, "bytes");
				InputStream in = (InputStream) IDataUtil.get(dataCursor, "stream");
				dataCursor.destroy();
				
				// process
								
				try
				{		
					if (!new File(fileName).getParentFile().exists());
						new File(fileName).getParentFile().mkdirs();
					
					if (bytes != null)
					{
						in = new ByteArrayInputStream(bytes);
					}
					else if (string != null)
					{
						in = new ByteArrayInputStream(string.getBytes());
					} 
					
					File targetFile = new File(fileName);
				    OutputStream outStream = new FileOutputStream(targetFile);
				 
				    byte[] buffer = new byte[8 * 1024];
				    int bytesRead;		       
				    
				    while ((bytesRead = in.read(buffer)) != -1) {
				    	
				    	outStream.write(buffer, 0, bytesRead);
				    }
				    
				    in.close();
				    outStream.close();
				    
				} catch(IOException e) {
					throw new ServiceException(e);
				}
				
				
				// pipeline out
				
				IDataUtil.put(pipelineCursor, "fileNameOnly", new File(fileName).getName());
				pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void writeMimeBodyToFile (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(writeMimeBodyToFile)>> ---
		// @sigtype java 3.5
		// [i] field:0:required path
		// [i] record:0:required data
		// [i] - field:0:optional string
		// [i] - object:0:optional bytes
		// [i] - object:0:optional stream
		// [i] field:0:optional ext
		// [o] field:0:required filename
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String path = IDataUtil.getString(pipelineCursor, "path");
		IData data = IDataUtil.getIData(pipelineCursor, "data");
		String ext = IDataUtil.getString(pipelineCursor, "ext");
		
		IDataCursor dataCursor = data.getCursor();
		String string = IDataUtil.getString(dataCursor, "string");
		byte[] bytes = (byte[]) IDataUtil.get(dataCursor, "bytes");
		InputStream stream = (InputStream) IDataUtil.get(dataCursor, "stream");
		
		dataCursor.destroy();
		
		// process
		
		if (string != null)
			stream = new ByteArrayInputStream(string.getBytes());
		else if (bytes != null)
			stream = new ByteArrayInputStream(bytes);
		
		MimeContentReader mf = new MimeContentReader(path, stream, ext);
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "filename", mf.lastReadFile);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void zipit (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(zipit)>> ---
		// @sigtype java 3.5
		// [i] field:0:required sourceFolder
		// [i] field:0:required zipFile
		// [o] field:0:required zipFile
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String sourceFolder = IDataUtil.getString(pipelineCursor, "sourceFolder");
		String zipFile = IDataUtil.getString(pipelineCursor, "zipFile");
				
		// process
				
		System.out.println("build dir is " + sourceFolder + ", preparing zip file " + zipFile);
				
		try {
			if (!zipFile.startsWith("/") && !zipFile.startsWith("./"))
				zipFile = new File(new File(sourceFolder).getParent(), zipFile).getAbsolutePath();
				
			if (!zipFile.endsWith(".zip"))
				zipFile += ".zip";
				
			new Zipper().zipIt(sourceFolder, zipFile);
				
			byte[] contents;
				
			contents = Files.readAllBytes(FileSystems.getDefault().getPath(zipFile));
		} catch (IOException e) {
			e.printStackTrace();
					
			throw new ServiceException("Cannot read zipped file '" + zipFile + "' " + e.getLocalizedMessage());
		}
				
		// pipeline out
				
		//IDataUtil.put(pipelineCursor, "contents", contents);
				
		if (zipFile != null)
			IDataUtil.put(pipelineCursor, "zipFile", new File(zipFile).getName());
				
			pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}

	// --- <<IS-START-SHARED>> ---
	
	public static class MimeContentReader {
		
		public String lastReadFile;
		public String fileName;
		public String contentType;
		
		private String _ext;
		private String _path;
		private String _marker;
		
		public MimeContentReader(String path, InputStream in, String ext) throws ServiceException {
			
			this._ext = ext;
			this._path = path;
			
			OutputStream out = null;
			byte[] buffer = new byte[8 * 1024];
		    int bytesRead = -1;
		    		    
		    try {
				while ((bytesRead=in.read(buffer)) != -1) {
					
					out = readMimeDataFromBuffer(buffer, bytesRead, out);
				}
		    } catch (IOException e) {
				throw new ServiceException(e);
		    } finally {
				
		    	if (out != null) {
		    		try {
						out.close();
					} catch (IOException e) {
						throw new ServiceException(e);
					}
		    	}
			}
		}
		
		public OutputStream readMimeDataFromBuffer(byte[] buffer, int bytesRead, OutputStream out) throws IOException {
					
		    System.out.println("processing buffer of " + bytesRead + " / " + out);
		    
			int indexIn = 0;
			
		    if (this.fileName == null) {
		    	
				boolean go = false;
				String line = null;
					    
				BufferedReader reader = new BufferedReader(new InputStreamReader(new ByteArrayInputStream(buffer)));
	
				while(!go && (line=reader.readLine()) != null) {
											
					indexIn += line.getBytes().length + 2;
					
					//System.out.println("processing line: " + line);
					
					if (_marker != null && line.length() == 0) {
						// hit body
						go = true;
						
						//indexIn += 1;
												
					} else if (this.fileName == null && line.startsWith("Content-Disposition")) {
						// read file name
						
						System.out.println("marker is " + _marker);
												
						if (line.indexOf("filename=") != -1)
							this.fileName = line.substring(line.indexOf("filename=")+10);
						else
							this.fileName = line.substring(line.indexOf("name=")+6);
	
						this.fileName = this.fileName.substring(0, this.fileName.indexOf("\""));
						
						System.out.println("Next file is " + this.fileName);
					}
					
					if (_marker == null && line.startsWith("--"))
						_marker = line;
					
				} // end while		
		    }
		    
		    // process body
		 
		 // shrink buffer to actual data read (happens when we get to the end of file)
			
			
			byte[] newBuf = null;
			
			if (indexIn > 0 || bytesRead < buffer.length) {
				newBuf = new byte[bytesRead-indexIn];
				int z = 0;
			    for (int i = indexIn; i < bytesRead; i++) {
			    	newBuf[z++] = buffer[i];
			    }
			    
			    System.out.println("shrink buf to " + newBuf.length);
			    
			    buffer = newBuf;
			}	
			
		    byte[] markerBytes = _marker.getBytes();
	
		    // now at content start, but have we reached start of next attachment too!
		    
		    byte[] lastFileBuf = null;
		    int indexOut = -1;
		    
		    if (buffer != null && new String(buffer).contains(_marker)) {
	    		
	    		// reached end marker
	    						    	
	    		indexOut = indexOf(buffer, markerBytes) - 2;
	    				    		
	    		System.out.println("end marker for file is at " + indexOut + " of " + buffer.length);
	    		
	    		if (indexOut > 0) {
	    			lastFileBuf = new byte[indexOut];
	    			int z = 0;
	    			for (int i = 0; i < indexOut; i++) {
	    				lastFileBuf[z++] = buffer[i];
	    			}
	    		}
	    		
	    		int end = indexOut+markerBytes.length+6;
	    		int size = buffer.length-end;
	    		
		    	System.out.println("remainder is " + end);
	
			    // prepare for next attachment if (any)
			    
			    if (size > 0) {
			    				    	
			    	byte[] nextFileBuf = new byte[size];
			    	int z = 0;
			    	for (int i = end; i < buffer.length; i++) {
			    		nextFileBuf[z++] = buffer[i];
			    	}
			    
			    	buffer = nextFileBuf;
			    	
			    } else {
			    	buffer = null;
			    }			    
	    	}
		    		    
		    if (out == null || lastFileBuf != null) {
					    	
		    	// current file not yet started, open it
		    	
		    	if (out == null) {
			    						
		    		if (_ext != null && !this.fileName.endsWith(_ext)) {
						if (_ext.startsWith("."))
							this.fileName += _ext;
						else
							this.fileName += "." + _ext;
					}
													
					out = new FileOutputStream(new File(_path, this.fileName));
		    	} 
		    	
		    	if (lastFileBuf != null) {
				
			    	// reached end of current file, write end of file
	
					System.out.println("finishing current file");
					
					out.write(lastFileBuf);
					out.close();
					this.lastReadFile = this.fileName;
					this.fileName = null;
					out = null;
					
					// start next file 
								
					if (buffer != null)
						out = this.readMimeDataFromBuffer(buffer, buffer.length, out);
					
					System.out.println(">>>>>> backing out of current remainder");
					
				} else {
					// end of file is outside of buffer, so just write buf
					
					System.out.println("writing current buffer to new file " + this.fileName + " / " + out);
					
					out.write(buffer);
				}
				
			} else if (buffer != null) {
				
				// right in the middle, so write buffer to existing output
				
				System.out.println("writing current buffer to " + this.fileName);
				
				out.write(buffer);
			}
		    
		    return out;
		}		
	}
	
	public static int indexOf(byte[] data, byte[] pattern) {
		   
		int[] failure = computeFailure(pattern);
	
	    int j = 0;
	
	    for (int i = 0; i < data.length; i++) {
	        while (j > 0 && pattern[j] != data[i]) {
	            j = failure[j - 1];
	        }
	        if (pattern[j] == data[i]) { 
	            j++; 
	        }
	        if (j == pattern.length) {
	            return i - pattern.length + 1;
	        }
	    }
	    return -1;
	}
	
	private static int[] computeFailure(byte[] pattern) {
	   
		int[] failure = new int[pattern.length];
	
	    int j = 0;
	    for (int i = 1; i < pattern.length; i++) {
	        while (j>0 && pattern[j] != pattern[i]) {
	            j = failure[j - 1];
	        }
	        if (pattern[j] == pattern[i]) {
	            j++;
	        }
	        failure[i] = j;
	    }
	
	    return failure;
	}
	
	public static String toHex(byte[] bytes) {
		BigInteger bi = new BigInteger(1, bytes);
		return String.format("%0" + (bytes.length << 1) + "X", bi);
	}
	
	private static IData makeValuesIntoIData(Values v) {
		
		IData out = IDataFactory.create();
		IDataCursor c = out.getCursor();
		
		Enumeration<String> e = v.keys();
		
		while (e.hasMoreElements()) {
			String key = e.nextElement();
			Object  value = v.get(key);
			
			IDataUtil.put(c, key, value);
		}
		
		c.destroy();
		return out;
	}
	
	private static class DirCopier extends SimpleFileVisitor<Path> {
		
		private Path _src;
		private Path _tgt;
		
		DirCopier(Path src, Path tgt) {
			
			this._src = src;
			this._tgt = tgt;
		}
		
		public void copy(boolean overwrite) throws IOException, ServiceException {
			
			if (this._tgt.toFile().exists() && overwrite)
				this._tgt.toFile().delete();
			else if (this._tgt.toFile().exists())
				throw new ServiceException("Target directory already exists and overwrite not specified!: " + this._tgt.toFile().getCanonicalPath());
			
			 Files.walkFileTree(_src, this);
		}
		
		@Override
	    public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) {
	 
	        try {
	            Path targetFile = _tgt.resolve(_src.relativize(file));
	            Files.copy(file, targetFile);
	        } catch (IOException ex) {
	            System.err.println(ex);
	        }
	 
	        return FileVisitResult.CONTINUE;
	    }
	 
	    @Override
	    public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attributes) {
	        try {
	            Path newDir = _tgt.resolve(_src.relativize(dir));
	            Files.createDirectory(newDir);
	        } catch (IOException ex) {
	            System.err.println(ex);
	        }
	 
	        return FileVisitResult.CONTINUE;
	    }
	}
	
	private static void deleteDir(File element) throws ServiceException {
	    if (element.isDirectory()) {
	    	if (element.listFiles() != null) {
	    		for (File sub : element.listFiles()) {
	    			deleteDir(sub);
	    		}
	    	}
	    }
	    		    
	    if (!element.delete())
	    	throw new ServiceException("Cannot delete file '" + element.getAbsolutePath());
	}
	
	private static List<String> listf(String dir, String filter) throws ServiceException {
		
		File directory = new File(dir);
	
	    List<String> resultList = new ArrayList<String>();
	
	    // get all the files from a directory
	    File[] fList = directory.listFiles();
	    
	    if (fList != null) {
	    	for (File file : fList) {
	    	
	    		if (file.isFile() && (filter == null || file.getName().matches(filter))) {
	    			resultList.add(file.getAbsolutePath());
	    	
	    		} else if (file.isDirectory()) {
	    			resultList.addAll(listf(file.getAbsolutePath(), filter));
	    		}
	    	}
	    
	    	return resultList;
	    } else {
	    	//throw new ServiceException("No files found for: " + dir);
	    	
	    	return null;
	    }
	}
	
	private static class Zipper {
		
		private String _sourceFolder;
		
		private List <String> fileList = new ArrayList<String>();
		
		public void zipIt(String sourceFolder, String zipFile) {
			
			this._sourceFolder = sourceFolder;
		
			this.generateFileList(new File(sourceFolder));
				
		    byte[] buffer = new byte[1024];
		    String source = new File(sourceFolder).getName();
		    FileOutputStream fos = null;
		    ZipOutputStream zos = null;
		    try {
		        fos = new FileOutputStream(zipFile);
		        zos = new ZipOutputStream(fos);
		
		        System.out.println("Output to Zip : " + zipFile);
		        FileInputStream in = null;
		
		        for (String file: this.fileList) {
		            System.out.println("File Added : " + file);
		            ZipEntry ze = new ZipEntry(source + File.separator + file);
		            zos.putNextEntry(ze);
		            try {
		                in = new FileInputStream(this._sourceFolder + File.separator + file);
		                int len;
		                while ((len = in .read(buffer)) > 0) {
		                    zos.write(buffer, 0, len);
		                }
		            } finally {
		                in.close();
		            }
		        }
		
		        zos.closeEntry();
		        System.out.println("Folder successfully compressed");
		
		    } catch (IOException ex) {
		        ex.printStackTrace();
		    } finally {
		        try {
		            zos.close();
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		    }
		}
		
		public void generateFileList(File node) {
		    // add file only
		    if (node.isFile()) {
		        fileList.add(generateZipEntry(node.toString()));
		    }
		
		    if (node.isDirectory()) {
		        String[] subNote = node.list();
		        for (String filename: subNote) {
		            generateFileList(new File(node, filename));
		        }
		    }
		}
		
		private String generateZipEntry(String file) {
					
		    return file.substring(_sourceFolder.length() + 1, file.length());
		}
	}
	
	public static class UnzipFiles {
		
	    private static void unzip(String zipFilePath, String destDir) {
	        File dir = new File(destDir);
	        // create output directory if it doesn't exist
	        if(!dir.exists()) dir.mkdirs();
	        FileInputStream fis;
	        //buffer for read and write data to file
	        byte[] buffer = new byte[1024];
	        try {
	            fis = new FileInputStream(zipFilePath);
	            ZipInputStream zis = new ZipInputStream(fis);
	            ZipEntry ze = zis.getNextEntry();
	            while(ze != null){
	                String fileName = ze.getName();
	                File newFile = new File(destDir + File.separator + fileName);
	                System.out.println("Unzipping to "+newFile.getAbsolutePath());
	                //create directories for sub directories in zip
	                new File(newFile.getParent()).mkdirs();
	                FileOutputStream fos = new FileOutputStream(newFile);
	                int len;
	                while ((len = zis.read(buffer)) > 0) {
	                fos.write(buffer, 0, len);
	                }
	                fos.close();
	                //close this ZipEntry
	                zis.closeEntry();
	                ze = zis.getNextEntry();
	            }
	            //close last ZipEntry
	            zis.closeEntry();
	            zis.close();
	            fis.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	        
	    }
	}
		
	// --- <<IS-END-SHARED>> ---
}

