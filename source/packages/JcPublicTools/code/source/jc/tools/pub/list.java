package jc.tools.pub;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class list

{
	// ---( internal utility methods )---

	final static list _instance = new list();

	static list _newInstance() { return new list(); }

	static list _cast(Object o) { return (list)o; }

	// ---( server methods )---




	public static final void containsString (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(containsString)>> ---
		// @sigtype java 3.5
		// [i] field:1:required list
		// [i] field:0:required key
		// [i] field:0:required matches {"false","true"}
		// [o] field:0:required found
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		String[]	list = IDataUtil.getStringArray(pipelineCursor, "list");
		String key = IDataUtil.getString(pipelineCursor, "key");
		String matches = IDataUtil.getString(pipelineCursor, "matches");
		
		boolean match = false;
		
		if (matches != null && matches.toLowerCase().equals("true"))
			match = true;
		
		// process
		
		boolean found = false;
		int index = 0;
		while (!found && index < list.length)
		{
			found = ((!match && list[index++].contentEquals(key)) ||
				(match && list[index++].indexOf(key) != -1));
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "found", found);
		pipelineCursor.destroy();
		
			
		// --- <<IS-END>> ---

                
	}



	public static final void convertToString (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(convertToString)>> ---
		// @sigtype java 3.5
		// [i] object:1:required list
		// [i] field:0:optional separator
		// [o] field:0:required out
		// pipeline in
		
		IDataCursor pipelineCursor = pipeline.getCursor();
		Object[] list = IDataUtil.getObjectArray(pipelineCursor, "list");
		String separator = IDataUtil.getString(pipelineCursor, "separator");
		
		// process
		
		if (separator == null)
			separator = ",";
		
		String out = "";
		
		if (list != null) {
			
			for(Object o : list) {
				out += "\"" + o.toString() + "\"" + separator;
			}
			
			if (list.length > 0)
				out = out.substring(0, out.length()-1);
		}
		
		// pipeline out
		
		IDataUtil.put(pipelineCursor, "out", out);
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}
}

