% P/invoke
assemblyInfo    = NET.addAssembly([pwd '\1-Framework\External\HDFql\HDFql.PInvoke.dll']);
import HDFql.PInvoke.*

dllFilePath = [pwd '\1-Framework\External\HDFql\'];

try
    HDFql.Execute('')
catch ex
    a = ex;
end