//  This file is part of YamlDotNet - A .NET library for YAML.
//  Copyright (c) 2008, 2009, 2010, 2011, 2012, 2013 Antoine Aubry
    
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
    
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
    
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


using System;

namespace YamlDotNet.Core.Tokens
{
	/// <summary>
	/// Represents a stream end event.
	/// </summary>
	public class StreamEnd : Token
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="StreamEnd"/> class.
		/// </summary>
		public StreamEnd()
			: this(Mark.Empty, Mark.Empty)
		{
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="StreamEnd"/> class.
		/// </summary>
		/// <param name="start">The start position of the token.</param>
		/// <param name="end">The end position of the token.</param>
		public StreamEnd(Mark start, Mark end)
			: base(start, end)
		{
		}
	}
}