using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinSence.Messages;
using UsMedia.KinSence.Server;
using UsMedia.KinSence.Interfaces;
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

        protected Runtime Nui { get { return Core.Nui; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS        

    }

}
