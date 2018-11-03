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
ad8c3125:
  datacenter: wec
  consul_node_name: service-discovery-server-0
  branch_name: cert
  environment: 'prod'
  unused1:
  unused2:
  unused3:
  unused4:
ad8c3126:
  datacenter: wec
  consul_node_name: service-discovery-server-1
  branch_name: cert
  environment: prod
  unused1:
  unused2:
  unused3:
  unused4:
";
		private StringReader sr = new StringReader(data);
		private YamlStream stream = new YamlStream();
		[SetUp]
		public void SetUp()
		{
			stream.Load((System.IO.TextReader)sr);
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
