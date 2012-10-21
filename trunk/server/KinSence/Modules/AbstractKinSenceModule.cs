///////////////////////////////////////////////////////////////////////////////////
//
// Licensed under the MIT license
//
// Copyright (c) 2012 Pieter van de Sluis, Us Media
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// http://www.usmedia.nl
//
///////////////////////////////////////////////////////////////////////////////////


using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Kinect;
using UsMedia.KinSence.Messages;
using UsMedia.KinSence.Server;
using UsMedia.KinSence.Modules;
using Newtonsoft.Json;

namespace UsMedia.KinSence.Modules
{
    public class AbstractKinSenceModule : IKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private string name;
        private IKinSenceCore core;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public AbstractKinSenceModule( string name )
        {
            this.name = name;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public virtual void OnRegister() { }

        public virtual void OnRemove() { }

        public virtual void OnClientMessage( string type, dynamic data ) { }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void SendMessage( string type, dynamic data )
        {
            Core.SendMessage( name, type, data );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public string Name { get { return this.name; } }

        public IKinSenceCore Core { get { return this.core; } set { this.core = value; } }

        protected KinectSensor Sensor { get { return Core.Sensor; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS        

    }

}
