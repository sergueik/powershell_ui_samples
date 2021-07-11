using System.Collections;
using System.Collections.ObjectModel;
using System.Linq;
using System.Web.Script.Serialization;
using System;
using System.Collections.Generic;
using System.Text;
using System.Dynamic;

// origin: https://www.codeproject.com/Articles/349646/Dynamic-JSON-parser

namespace Utils {
	public sealed class DynamicJsonConverter : JavaScriptConverter {
		public override object Deserialize(IDictionary<string, object> dictionary, Type type, JavaScriptSerializer serializer) {
			if (dictionary == null)
				throw new ArgumentNullException("dictionary");

			return type == typeof(object) ? new DynamicJsonObject(dictionary) : null;
		}

		public override IDictionary<string, object> Serialize(object obj, JavaScriptSerializer serializer) {
			throw new NotImplementedException();
		}

		public override IEnumerable<Type> SupportedTypes {
			get { return new ReadOnlyCollection<Type>(new List<Type>(new[] { typeof(object) })); }
		}
	}
	
	public class DynamicConsoleWriter : DynamicObject {
		protected string first = "";
		protected string last = "";

		public int Count {
			get {
				return 2;
			}
		}

		public override bool TryBinaryOperation(BinaryOperationBinder binder, object arg, out object result) {
			bool success = false;

			if (binder.Operation == System.Linq.Expressions.ExpressionType.Add) {
				Console.WriteLine("I have to think about that");
				success = true;
			}

			result = this;
			return success;
		}

		public override bool TryUnaryOperation(UnaryOperationBinder binder, out object result) {
			bool success = false;

			if (binder.Operation == System.Linq.Expressions.ExpressionType.Increment) {
				Console.WriteLine("I will do it later");
				success = true;
			}

			result = this;
			return success;
		}

		public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result) {
			result = null;
			if ((int)indexes[0] == 0) {
				result = first;
			} else if ((int)indexes[0] == 1) {
				result = last;
			}

			return true;
		}

		public override bool TrySetIndex(SetIndexBinder binder, object[] indexes, object value) {
			if ((int)indexes[0] == 0) {
				first = (string)value;
			} else if ((int)indexes[0] == 1) {
				last = (string)value;
			}

			return true;
		}

		public override bool TryGetMember(GetMemberBinder binder, out object result) {
			string name = binder.Name.ToLower();
			bool success = false;
			result = null;

			if (name == "last") {
				result = last;
				success = true;
			} else if (name == "first") {
				result = first;
				success = true;
			}

			return success;
		}

		public override bool TrySetMember(SetMemberBinder binder, object value) {
			string name = binder.Name.ToLower();
			bool success = false;

			if (name == "last") {
				last = (string)value;
				success = true;
			} else if (name == "first") {
				first = (string)value;
				success = true;
			}

			return success;
		}

		public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result) {
			string name = binder.Name.ToLower();
			bool success = false;

			result = true;

			if (name == "writelast") {
				Console.WriteLine(last);
				success = true;
			} else if (name == "writefirst") {
				Console.WriteLine(first);
				success = true;
			}

			return success;
		}
	}

	public class ReadOnlyDictionary<TKey, TValue> : IDictionary<TKey, TValue> {
		private IDictionary<TKey, TValue> mDictionary;

		public ReadOnlyDictionary() {
			mDictionary = new Dictionary<TKey, TValue>();
		}

		public ReadOnlyDictionary(IDictionary<TKey, TValue> dictionary) {
			mDictionary = dictionary;
		}

		#region IDictionary<TKey,TValue> Members
		public void Add(TKey key, TValue value) {
			throw new NotSupportedException("This dictionary is read-only");
		}
		public bool ContainsKey(TKey key) {
			return mDictionary.ContainsKey(key);
		}

		public ICollection<TKey> Keys {
			get { return mDictionary.Keys; }
		}

		public bool Remove(TKey key) {
			throw new NotSupportedException("This dictionary is read-only");
		}

		public bool TryGetValue(TKey key, out TValue value) {
			return mDictionary.TryGetValue(key, out value);
		}
		public ICollection<TValue> Values {
			get { return mDictionary.Values; }
		}
		public TValue this[TKey key] {
			get {
				return mDictionary[key];
			}
			set {
				throw new NotSupportedException("This dictionary is read-only");
			}
		}

		#endregion

		#region ICollection<KeyValuePair<TKey,TValue>> Members

		public void Add(KeyValuePair<TKey, TValue> item) {
			throw new NotSupportedException("This dictionary is read-only");
		}
		public void Clear() {
			throw new NotSupportedException("This dictionary is read-only");
		}

		public bool Contains(KeyValuePair<TKey, TValue> item) {
			return mDictionary.Contains(item);
		}

		public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex) {
			mDictionary.CopyTo(array, arrayIndex);
		}

		public int Count {
			get { return mDictionary.Count; }
		}

		public bool IsReadOnly {
			get { return true; }
		}

		public bool Remove(KeyValuePair<TKey, TValue> item) {
			throw new NotSupportedException("This dictionary is read-only");
		}

		#endregion

		#region IEnumerable<KeyValuePair<TKey,TValue>> Members

		public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator() {
			return mDictionary.GetEnumerator();
		}

		#endregion

		#region IEnumerable Members

		System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() {
			return (mDictionary as System.Collections.IEnumerable).GetEnumerator();
		}
		#endregion
	}

	public class DynamicJsonObject : DynamicObject, IEnumerable {
        private readonly IDictionary<string, object> mDictionary;

		public DynamicJsonObject(IDictionary<string, object> dictionary = null){
			mDictionary = (dictionary == null) ?
            	new Dictionary<string, object>() : dictionary;            
		}

        public IDictionary<string, object> Dictionary {
            get { return new ReadOnlyDictionary<string, object>(mDictionary); }
        }
        public override string ToString() {
            var sb = new StringBuilder();
            ToString(ref sb);
            return sb.ToString();
        }

        private void ToString(ref StringBuilder sb) {
            sb.Append("{");

            var needComma = false;
            foreach (var pair in mDictionary) {
                if (needComma) {
                    sb.Append(",");
                }
                needComma = true;
                var value = pair.Value;
                var name = pair.Key;

                if (value == null) {
                    sb.AppendFormat("\"{0}\":\"{1}\"", name, "");
                }
                else {
                    sb.AppendFormat("\"{0}\":", name);
                    var serializer = new JavaScriptSerializer();
                    serializer.RegisterConverters(new [] { new DynamicJsonObjectConverter() });
                    serializer.Serialize(value, sb);
                }
            }
            sb.Append("}");
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result) {
            if (!mDictionary.TryGetValue(binder.Name, out result)){
                result = null;
                return true;
            }

            var dictionary = result as IDictionary<string, object>;
            if (dictionary != null) {
                result = new DynamicJsonObject(dictionary);
                return true;
            }

            var arrayList = result as ArrayList;
            if (arrayList != null && arrayList.Count > 0) {
                if (arrayList[0] is IDictionary<string, object>)
                    result = new List<object>(arrayList.Cast<IDictionary<string, object>>().Select(x => new DynamicJsonObject(x)));
                else
                    result = new List<object>(arrayList.Cast<object>());
            }

            return true;
        }


        public override bool TrySetMember(SetMemberBinder binder, object value) {
            mDictionary[binder.Name] = value;
            return true;
        }

        #region Enumeration

        IEnumerator IEnumerable.GetEnumerator() {
            return (IEnumerator)GetEnumerator();
        }

        public IEnumerator GetEnumerator() {
            foreach (var kv in mDictionary) {
                yield return kv;
            }
        }

        #endregion
    }

    public sealed class DynamicJsonObjectConverter : JavaScriptConverter {
        public override object Deserialize(IDictionary<string, object> dictionary, Type type, JavaScriptSerializer serializer) {
            throw new NotImplementedException();
        }

        public override IDictionary<string, object> Serialize(object obj, JavaScriptSerializer serializer) {
            var result = new Dictionary<string, object>();

            var dynamicJsonObject = obj as DynamicJsonObject;
            foreach (var item in dynamicJsonObject.Dictionary) {
                result.Add(item.Key, item.Value);
            }

            return result;
        }

        public override IEnumerable<Type> SupportedTypes {
            get { return new Type[] { typeof(DynamicJsonObject) }; }
        }
    }

    public class Specificity {
        public static void printDynamic(dynamic obj) {
            print(obj);
        }

        protected static void print(List<int> list) {
            foreach (var item in list) {
                Console.WriteLine(item);
            }
        }

        protected static void print(object obj) {
            Console.WriteLine("I do not know how to print you");
        }

    }
}
