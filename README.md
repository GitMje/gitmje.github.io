## Michael Erpenbeck

When reviewing code and mentoring developers via pair programming, I have learned to watch for the statement `throw ex;` in a catch block. As shown in the code snippet below:

```csharp
catch (Exception ex)
{
    Log(ex);
    throw ex;
}
```

The differences between `throw;` and `throw ex;` are rarely understood by the average and even the advanced C# developer. These concepts are simple and I will illustrate the differences in this blog post.

Using `throw ex;` (or `throw e;` based on the name of the Exception variable) is typically a bad idea. The reason is that ex will lose the most recent stack trace element and could point a developer to the wrong place. In contrast “throw;”, also known as a rethrow, will preserve the original stack trace.

To illustrate, let us assume that we have the following C# console application 1I am using `catch (Exception ex)` in these examples for simplicity. A best practice is to always catch the most specific type of Exception known, e.g., in this case that would be NotImplementedException.[1].

```csharp
using System;
 
namespace rethrow_blog_example
{
    class Program
    {
        static void Main(string[] args)
        {
            var p = new Program();
            p.ReCatchIt();
        }
 
        private void Log(Exception exception)
        {
            // Do some basic logging here.
        }
 
        private void ThrowIt()
        {
            throw new NotImplementedException("This is an example exception");
        }
 
        private void CatchIt()
        {
            try
            {
                ThrowIt();
            }
            catch (Exception ex)
            {
                Log(ex);
                // Bad
                throw ex;
            }
        }
        
        private void ReCatchIt()
        {
            try
            {
                CatchIt();
            }
            catch (Exception ex2)
            {
                Console.WriteLine("ExceptionType: {0}", ex2.GetType().Name);
                Console.WriteLine("Message: {0}", ex2.Message);
                Console.WriteLine("TargetSite: {0}", ex2.TargetSite);
                Console.WriteLine("StackTrace:\n{0}", ex2.StackTrace);
            }
        }
    }
}
```

The ReCatchIt method calls the CatchIt method. The CatchIt method catches and throws the Exception ex using a `throw ex;` statement. The output of this program is shown below:

```markdown
ExceptionType: NotImplementedException
Message: This is an example exception
TargetSite: Void CatchIt()
StackTrace:
   at rethrow_blog_example.Program.CatchIt() in ...\Program.cs:line 33
   at rethrow_blog_example.Program.ReCatchIt() in ...\Program.cs:line 41
```

Notice that because of the `throw ex;` syntax, both the StackTrace and the TargetSite erroneously shows that the Exception is coming from the CatchIt method, and not the real source of the problem in the ThrowIt method.

In contrast, if the code is changed to rethrow using the `throw;` syntax, as shown below:

```csharp
        private void CatchIt()
        {
            try
            {
                ThrowIt();
            }
            catch (Exception ex)
            {
                Log(ex);
                // Good
                throw;
            }
        }
```
The output from this program will look like the following:

```markdown
ExceptionType: NotImplementedException
Message: This is an example exception
TargetSite: Void ThrowIt()
StackTrace:
   at rethrow_blog_example.Program.ThrowIt() in ...\Program.cs:line 20
   at rethrow_blog_example.Program.CatchIt() in ...\Program.cs:line 33
   at rethrow_blog_example.Program.ReCatchIt() in ...\Program.cs:line 41
```

Now the ThrowIt method is being correctly identified as the evil doer. Notice also, that the ExceptionType and the Message are correctly reported by both the `throw ex;` and the `throw;` statements.

At this point, you may be saying, ‘OK, got it, always use `throw;`!’. Like most things in programming, however, the art is in the nuance. For example, if you are developing a 3rd party library, you may decide to wrap the Exceptions in an ApplicationException or Custom Exceptions to provide your client with meaningful information to resolve their issues. See the code example below:

```csharp
        private void CatchIt()
        {
            try
            {
                ThrowIt();
            }
            catch (Exception ex)
            {
                Log(ex);
                // Alternative to give more information:
                throw new CustomException("A helpful message to your clients on how to resolve their issue", ex);
            }
        }
```

Note, there’s some debate on the usefulness of the ApplicationException class and whether Custom Exceptions should be derived from the ApplicationException class or just the Exception class…See [ApplicationException](https://blogs.msdn.microsoft.com/brada/2004/03/25/introducing-the-net-framework-standard-library-annotated-reference-vol1/) details for more information.

So next time that you see a `throw ex;` statement in a catch block, make sure that you ask yourself…”Is the intent of this code to do a rethrow and keep the full stack trace, or to capture more information with a Custom Exception”?