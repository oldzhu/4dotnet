using System;

namespace dotnethello
{
	class Program
	{
		static void Main(string[] args)
		{
			var coreAssemblyInfo = System.Diagnostics.FileVersionInfo.GetVersionInfo(typeof(object).Assembly.Location);
			Console.WriteLine($"Hello World from .NET {coreAssemblyInfo.ProductVersion}");
			Console.WriteLine($"The location is {typeof(object).Assembly.Location}");
		}
	}
}
