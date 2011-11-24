/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2011 Pieter van de Sluis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.utils.reflector
{
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;


    /**
	 * @author Pieter van de Sluis
	 */
	public class Reflector
	{
		
		public static function getProperties( target:*, accessType:String = null ):/*PropertyDefinition*/Array
		{
			var xml:XMLList = getNodes( target, accessType );
			
			return getPropDefs( xml );
		}
		
		
		public static function getProperty( target:*, propertyName:String ):PropertyDefinition
		{
			var xml:XMLList = getNodes( target );
			var node:XML = xml.( attribute( "name" ) == propertyName )[0];
			
			if ( node )
				return getPropDef( node );
				
			return null;
		}
		
		
		private static function getNodes( target:*, accessType:String = null ):XMLList
		{
			var nodes:XMLList = describeType( target ).descendants();
			
			var result:XMLList = nodes.( name() == "variable" );
			
			if ( accessType )
			{
				result += nodes.( name() == "accessor" && attribute("access") == "readwrite" );
				
				switch( accessType )
				{
					case AccessType.READ:
						result += nodes.( name() == "accessor" && attribute("access") == "readonly" );
					break;
					
					case AccessType.WRITE:
						result += nodes.( name() == "accessor" && attribute("access") == "writeonly" );
					break;
				}
			}
			else
			{
				result += nodes.( name() == "accessor" );
			}
			
			return result;
		}
		
		
		private static function getPropDefs( xmlList:XMLList ):/*PropertyDefinition*/Array
		{
			var result:Array = [];
			
			for each ( var node:XML in xmlList ) 
			{
				result[ result.length ] = getPropDef( node );
			}
			
			return result;
		}
		
		
		private static function getPropDef( node:XML ):PropertyDefinition
		{
			var name:String 		= node.attribute("name");
			var classRef:Class 		= Class( getDefinitionByName( node.attribute("type") ) );
			var isReadWrite:Boolean = node.name() == "variable" || node.attribute("access") == "readwrite";
			var isReadable:Boolean 	= isReadWrite || node.attribute("access") == "readonly"; 
			var isWriteable:Boolean = isReadWrite || node.attribute("access") == "writeonly"; 
			 
			return new PropertyDefinition( name, classRef, isReadable, isWriteable );
		}
		
	}

}