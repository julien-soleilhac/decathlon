package jc.tools.pub;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import com.wm.app.b2b.server.ServerAPI;
import com.wm.app.b2b.server.ServerStartupNotifier;
// --- <<IS-END-IMPORTS>> ---

public final class misc

{
	// ---( internal utility methods )---

	final static misc _instance = new misc();

	static misc _newInstance() { return new misc(); }

	static misc _cast(Object o) { return (misc)o; }

	// ---( server methods )---




	public static final void getNextUniqueCode (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getNextUniqueCode)>> ---
		// @sigtype java 3.5
		// [i] field:0:optional prefix
		// [i] field:0:required numDigits
		// [i] field:0:required numeric {"true","false"}
		// [o] field:0:required code
		IDataCursor c = pipeline.getCursor();
		String numDigits = IDataUtil.getString(c, "numDigits");
		String prefix = IDataUtil.getString(c, "prefix");
		String numeric = IDataUtil.getString(c, "numeric");
		
		String nextCode;
		
		if (numeric != null && numeric.equalsIgnoreCase("true"))
			nextCode = rotateNums(numDigits != null ? Integer.parseInt(numDigits) : 5);
		else
			nextCode = rotateChars(numDigits != null ? Integer.parseInt(numDigits) : 5);
		
		if (prefix != null)
			nextCode = prefix + nextCode;
		
		IDataUtil.put(c, "code", nextCode);
		
		c.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void runOnServerReady (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(runOnServerReady)>> ---
		// @sigtype java 3.5
		// [i] field:0:required service
		
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		String	service = IDataUtil.getString(pipelineCursor, "service");
		pipelineCursor.destroy();
		
		
		new ServerStartupNotifier().registerForStartup(service, pipeline);
			
		// --- <<IS-END>> ---

                
	}



	public static final void sleep (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(sleep)>> ---
		// @sigtype java 3.5
		// [i] field:0:required delay
		
		// pipeline in
		IDataCursor pipelineCursor = pipeline.getCursor();
		String delay = IDataUtil.getString(pipelineCursor, "delay");
		pipelineCursor.destroy();
		
		try {
			Thread.sleep(Long.parseLong(delay));
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		// --- <<IS-END>> ---

                
	}

	// --- <<IS-START-SHARED>> ---
	static int _num = 0;
	static char[] _chars = {'A', 'A', 'A', 'A', 'A'};
	static String zeros = "000000";
	
	static {
		restoreSequences();
	}
	
	public static void restoreSequences() {
		
		Path path = FileSystems.getDefault().getPath("./packages/JcPublicTools/config", "sequence-num.dat");
		try {
			_num = new BigInteger(Files.readAllBytes(path)).intValue();
		} catch (IOException e) {
			ServerAPI.logError(new ServiceException("Can't read num sequence file from disk: " + e.getLocalizedMessage()));
		}
		
		path = FileSystems.getDefault().getPath("./packages/JcPublicTools/config", "sequence-chars.dat");
		try {
			_chars = new String(Files.readAllBytes(path)).toCharArray();
		} catch (IOException e) {
			ServerAPI.logError(new ServiceException("Can't read char sequence file from disk: " + e.getLocalizedMessage()));
		}
	}
	
	public static synchronized void saveNumSequence() {
		
		Path path = FileSystems.getDefault().getPath("./packages/JcPublicTools/config", "sequence-num.dat");
		try {
			Files.write(path, BigInteger.valueOf(_num).toByteArray(), StandardOpenOption.CREATE);
		} catch (IOException e) {
			ServerAPI.logError(new ServiceException("Can't write sequence file to disk: " + e.getLocalizedMessage()));
		}
	}
	
	public static synchronized void saveCharSequence() {
		
		Path path = FileSystems.getDefault().getPath("./packages/JcPublicTools/config", "sequence-chars.dat");
		try {
			Files.write(path, new String(_chars).getBytes(), StandardOpenOption.CREATE);
		} catch (IOException e) {
			ServerAPI.logError(new ServiceException("Can't write sequence file to disk: " + e.getLocalizedMessage()));
		}
	}
	
	
	public static synchronized String rotateNums(int numDigits)
	{
		_num += 1;
						
		String num = "" + _num;
					
		if (num.length() > numDigits) {
			num = "0";
			_num = 0;
		}
		
		if (numDigits - num.length() > 0)
			num = zeros.substring(0, numDigits - num.length()) + num;
		
		saveNumSequence();
	
		return num;
	}
			
	public static synchronized String rotateChars(int numDigits)
	{
		if (_chars[4]++ == 'Z')
		{
			_chars[4] = 'A';
			_chars[3] += 1;
		}
		
		if (numDigits >= 1 && _chars[3] == 'Z')
		{
			_chars[3] = 'A';
			_chars[2] += 1;
		}
		
		if (numDigits > 2 && _chars[2] == 'Z')
		{
			_chars[2] = 'A';
			_chars[1] += 1;
		}
		
		if (numDigits > 3 && _chars[1] == 'Z')
		{
			_chars[1] = 'A';
			_chars[0] += 1;
		}
		
		if (numDigits > 4 && _chars[0] == 'Z')
		{
			// reset
			
			_chars[0] = 'A';
			_chars[1] = 'A';
			_chars[2] = 'A';
			_chars[3] = 'A';
			_chars[4] = 'A';
		}
		
		saveCharSequence();
	
		if (numDigits >= 5)
			return "" + _chars[0] + _chars[1] + _chars[2] + _chars[3] + _chars[4];
		else if (numDigits >= 4)
			return "" + _chars[1] + _chars[2] + _chars[3] + _chars[4];
		else if (numDigits >= 3)
			return "" + _chars[2] + _chars[3] + _chars[4];
		else
			return "" + _chars[3] + _chars[4];
	}
		
	// --- <<IS-END-SHARED>> ---
}

