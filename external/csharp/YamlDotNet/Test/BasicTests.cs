using System;
using System.Text;
using NUnit.Framework;
using FluentAssertions;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using YamlDotNet.Core;
using YamlDotNet.Core.Events;
using YamlDotNet.RepresentationModel;

namespace YamlDotNet.RepresentationModel.Test
{
	[TestFixture]
	public class BasicTests
	{
		private StringBuilder verificationErrors = new StringBuilder();
		private static String data = @"---
key1:
  datacenter: 'data center'
  param1: 
    - 'a'
    - 'b' 
    - 'c'
  param2:
    param3: 'data'
  param4: []
key2:
  datacenter: 'data center '
  param1: 
    - 'a'
    - 'b' 
    - 'c'
  param2:
    param3: 'data'
  param5: {}
# param3:
";
		private StringReader sr = new StringReader(data);
		private YamlStream stream = new YamlStream();
		[SetUp]
		public void SetUp()
		{
			stream.Load((System.IO.TextReader)sr);
			/*
			 SetUp : YamlDotNet.Core.YamlException : (Lin: 10, Col: 0, Chr: 175) - (Lin: 10, Col: 8, Chr: 183): Duplicate key
  ----> System.ArgumentException : An item with the same key has already been added. - c:\developer\sergueik\powershell_ui_samples\external\csharp\YamlDotNet\YamlDotNet.RepresentationModel\
  YamlMappingNode.cs:74
			 */
		}

		[TearDown]
		public void TearDown()
		{
			Assert.AreEqual("", verificationErrors.ToString());
		}

		[Test]
		public void ShouldWaitForAngular()
		{
			Assert.AreEqual(1, stream.Documents.Count);
			Assert.IsInstanceOfType(typeof(YamlMappingNode), stream.Documents[0].RootNode);
		}
	}
}
