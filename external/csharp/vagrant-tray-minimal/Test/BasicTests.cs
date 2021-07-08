using System;
using System.Text;
using NUnit.Framework;
using System.Web.Script.Serialization;
using System.Collections;
using Utils;
namespace Test
{
	[TestFixture]
	public class BasicTests
	{
		private JavaScriptSerializer serializer;
		private StringBuilder verificationErrors = new StringBuilder();
		private const string json = "{  \"firstName\": \"John\",  \"lastName\" : \"Smith\",  \"age\"      : 25,  \"address\"  :  {  \"streetAddress\": \"21 2nd Street\",  \"city\"         : \"New York\",  \"state\"        : \"NY\",  \"postalCode\"   : \"11229\"  },  \"phoneNumber\":  [  {  \"type\"  : \"home\",  \"number\": \"212 555-1234\"  },  {  \"type\"  : \"fax\",  \"number\": \"646 555-4567\"  }  ]  }";
		private dynamic data;
		
		[SetUp]
		public void SetUp() {
			serializer = new JavaScriptSerializer();
			serializer.RegisterConverters(new[] { new DynamicJsonConverter() });
		}

		[TearDown]
		public void TearDown() {
			Assert.AreEqual("", verificationErrors.ToString());
		}

		[Test] 
		// expect successfully load JSON data via dynamic types
		public void ShouldDeserialize() {
			// The contextual keyword 'var' may only appear within a local variable declaration
			// Implicitly-typed local variables must be initialized

			data = serializer.Deserialize<object>(json);
			Assert.IsNotNull(data);
			var value = data.firstName; 
			Assert.AreEqual("John", data.firstName);
			value = data.lastName;
		
			Assert.AreEqual("Smith", value);
			value = data.age;
			Assert.AreEqual(25, data.age);

			value = data.address.postalCode; // 11229
			Assert.AreEqual("11229", value);
			int count = data.phoneNumber.Count;
			Assert.AreEqual(2, count);

			
			
			value = data.phoneNumber[0].type; 
			Assert.AreEqual("home", value);
			Assert.AreEqual("fax", data.phoneNumber[1].type);

			foreach (var value2 in data.phoneNumber) {
				value = value2.number;
				StringAssert.IsMatch("(?:212 555-1234|646 555-4567)", value);
			}

		}
			
		
		[Test]
		// and creating JSON formatted data
		public void ShouldSerialize() {
	
			data = new DynamicJsonObject();
			dynamic item1 = new DynamicJsonObject();
			dynamic item2 = new DynamicJsonObject();

			var items = new ArrayList();

			item1.Name = "Drone";
			item1.Price = 92000.3;
			item2.Name = "Jet";
			item2.Price = 19000000.99;

			items.Add(item1);
			items.Add(item2);
			var items3 = new ArrayList();
			items3.Add(10);
			items3.Add(20);
			items3.Add(30);
			items.Add(items3);
			
			data.Date = "06/06/2004";
			data.Items = items;

			StringAssert.Contains("\"Name\":\"Drone\"", data.ToString());
			// Console.WriteLine(data.ToString());
		}
	
		[Test]
		// and creating JSON formatted data from empty 
		public void ShouldSerializeNothing() {
	
			data = new DynamicJsonObject();
			// Assert.Equals should not be used for Assertions
			// StringAssert.Equals("{}", data.ToString());
			Assert.AreEqual("{}", data.ToString());
			var items = new ArrayList();
			data.Items = items;

			Console.WriteLine(data.ToString());
			Assert.AreEqual("{\"Items\":[]}", data.ToString());

		}
		
		[Ignore]
		[Test]
		// Limitation: cannot create JSON Arrays
		// Future?
		public void ShouldSerializeArray() {
			var items = new ArrayList();
			// cannot compile
			// data = new DynamicJsonObject(items);
		}
	}
}
