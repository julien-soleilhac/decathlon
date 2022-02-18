package jc.tools.pub;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import com.ibm.icu.util.StringTokenizer;
// --- <<IS-END-IMPORTS>> ---

public final class string

{
	// ---( internal utility methods )---

	final static string _instance = new string();

	static string _newInstance() { return new string(); }

	static string _cast(Object o) { return (string)o; }

	// ---( server methods )---




	public static final void firstSentence (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(firstSentence)>> ---
		// @sigtype java 3.5
		// [i] field:0:required inString
		// [o] field:0:required outString
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String inString = IDataUtil.getString(pipelineCursor, "inString");
		
		// process
		
		String outString = inString;
		int index = inString.indexOf("! ");
		
		if (index == -1)
			index = inString.indexOf("? ");
		if (index == -1)
			index = inString.indexOf(". ");
		if (index == -1)
			index = inString.indexOf("; ");
		if (index == -1)
			index = inString.indexOf(", ");
		if (index != -1)
			outString = inString.substring(0, index);
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "outString", outString);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void reverseTokenize (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(reverseTokenize)>> ---
		// @sigtype java 3.5
		// [i] field:0:required inString
		// [i] field:0:required delim
		// [o] field:1:required valueList
		// [o] field:0:required last
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String inString = IDataUtil.getString(pipelineCursor, "inString");
		String delim = IDataUtil.getString(pipelineCursor, "delim");
		
		// process
		
		String[] valueList = null;
		
		if (delim == null)
			delim = ",";
		
		if (inString != null) {
			
			StringTokenizer tk = new StringTokenizer(inString, delim);
			int count = tk.countTokens();
			valueList = new String[count];
			
			while (tk.hasMoreTokens()) {
				valueList[--count] = tk.nextToken();
			}
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "valueList", valueList);
		IDataUtil.put(pipelineCursor, "last", valueList[valueList.length-1]);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void stringPart (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(stringPart)>> ---
		// @sigtype java 3.5
		// [i] field:0:required string
		// [i] field:0:required delimiter
		// [i] field:0:required part? {"first","last"}
		// [i] field:0:required index?
		// [o] field:0:required result
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String string = IDataUtil.getString(pipelineCursor, "string");
		String delimiter = IDataUtil.getString(pipelineCursor, "delimiter");
		String part = IDataUtil.getString(pipelineCursor, "part?" );
		String index = IDataUtil.getString(pipelineCursor, "index?");
		
		// process
		
		String result = null;
		
		if (delimiter == null)
			delimiter = " ";
		
		int indexInt = -1;
		
		try { indexInt = Integer.parseInt(index); }  catch(Exception e) {}
		
		if (string !=  null) {
			String tk[] = string.split(delimiter);
			
			if (indexInt != -1) {
				
				if (indexInt < tk.length)
					result = tk[indexInt];
				else
					result = tk[tk.length-1];
				
			} else if (part.equalsIgnoreCase("first")) {
				result = tk[0];
			} else if (part.equalsIgnoreCase("last")) {
				result = tk[tk.length-1];
			}
		}
		
		// pipeline out
		
		if (result !=  null)
			IDataUtil.put(pipelineCursor, "result", result);
		
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void urlEncode (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(urlEncode)>> ---
		// @sigtype java 3.5
		// [i] field:0:required in
		// [o] field:0:required out
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String in = IDataUtil.getString(pipelineCursor, "in");
		pipelineCursor.destroy();
		
		// process
		
		String out;
		try {
			out = URLEncoder.encode(in, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new ServiceException(e);
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "out", out);
		pipelineCursor.destroy();
		
			
		// --- <<IS-END>> ---

                
	}
}

