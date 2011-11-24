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

package nl.imotion.evo
{
    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.Gene;
    import nl.imotion.evo.genes.IntGene;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;


    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:10:19
     */
    public class Genome
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _genes:Vector.<Gene>;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Genome()
        {
            _genes = new Vector.<Gene>();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function mutate( mutationEffect:Number = 1, updateMomentum:Boolean = false ):Genome
        {
            var numGenes:uint = _genes.length;
            for ( var i:int = 0; i < numGenes; i++ )
            {
                _genes[ i ].mutate( mutationEffect, NaN, updateMomentum );
            }

            return this;
        }


        public function addGene( gene:Gene ):Gene
        {
            _genes.push( gene );

            return gene;
        }


        public function apply( target:* ):*
        {
            var numGenes:uint = genes.length;
            for ( var i:int = 0; i < numGenes; i++ )
            {
                var gene:Gene = genes[i];
                target[ gene.propName ] = gene.getPropValue();
            }
            
            return target;
        }


        public function getGeneByPropName( propName:String ):Gene
        {
            var numGenes:uint = _genes.length;

            for ( var i:int = 0; i < numGenes; i++ )
            {
                var gene:Gene = _genes[i];

                if ( gene.propName == propName )
                    return gene;
            }
            
            return null;
        }


        public function editGene( propName:String, props:Object ):Gene
        {
            var gene:Gene = getGeneByPropName( propName );

            if ( !gene )
            {
                throw new Error( "Gene with propname " + propName + " does not exist");
            }
            else
            {
                for ( var name:String in props )
                {
                    try
                    {
                        gene[ name ] = props[ name ];
                    }
                    catch( e:Error )
                    {
                        throw new Error( "Property " + name + " not found on Gene" );
                    }
                }
            }

            return gene;
        }


        public function resetGenes( geneNames:Array = null ):void
        {
            var resetList:Vector.<Gene>;

            if ( geneNames )
            {
                resetList = new Vector.<Gene>();

                var numNames:uint = geneNames.length;
                for ( var i:int = 0; i < numNames; i++ )
                {
                    var gene:Gene = getGeneByPropName( geneNames[ i ] );
                    if ( gene )
                    {
                        resetList[ resetList.length ] = gene;
                    }
                }
            }
            else
            {
                resetList = _genes;
            }

            var numGenes:uint = resetList.length;
            for ( var j:int = 0; j < numGenes; j++ )
            {
                resetList[ j ].reset();
            }
        }


        public function mate( mateGenome:Genome ):Genome
        {
            var offspring:Genome = clone();

            var numGenes:uint = _genes.length;
            for ( var i:int = 0; i < numGenes; i++ )
            {
                offspring._genes[ i ].baseValue = Math.random() < 0.5 ? _genes[ i ].baseValue : mateGenome.genes[ i ].baseValue;
            }

            return offspring;
        }


        public function clone():Genome
        {
            var clone:Genome = new Genome();

            var numGenes:uint = _genes.length;
            for ( var i:int = 0; i < numGenes; i++ )
            {
                clone.addGene( _genes[i].clone() );
            }

            return clone;
        }


        public function toXML():XML
        {
            var xml:XML = <genome />;

            for ( var i:int = 0; i < _genes.length; i++ )
            {
                xml.appendChild( _genes[ i ].toXML() );
            }

            return xml;
        }


        public function fromXML( xml:XML ):Genome
        {
            for each ( var geneNode:XML in xml.children() )
            {
                var geneType:String = geneNode.@type.toString();

                switch( true )
                {
                    case geneType == "int":
                        this.addGene(
                                new IntGene( geneNode.@propName.toString(), int( geneNode.@minVal.toString() ),
                               int( geneNode.@maxVal.toString() ), Number( geneNode.@mutationEffect.toString() ),
                                geneNode.@limitMethod.toString(), Number( geneNode.@baseValue.toString() ) )
                                );
                    break;

                    case geneType == "uint":
                        this.addGene(
                                new UintGene( geneNode.@propName.toString(), int( geneNode.@minVal.toString() ),
                               int( geneNode.@maxVal.toString() ), Number( geneNode.@mutationEffect.toString() ),
                                geneNode.@limitMethod.toString(), Number( geneNode.@baseValue.toString() ) )
                                );
                    break;

                    case geneType == "Number":
                        this.addGene(
                                new NumberGene( geneNode.@propName.toString(), Number( geneNode.@minVal.toString() ),
                               Number( geneNode.@maxVal.toString() ), Number( geneNode.@mutationEffect.toString() ),
                                geneNode.@limitMethod.toString(), Number( geneNode.@baseValue.toString() ) )
                                );
                    break;

                    case geneType == "Collection":
                        var collection:Array = [];

                        for each ( var collectionNode:XML in geneNode.children() )
                        {
                            collection.push( collectionNode.valueOf().toString() )
                        }

                        this.addGene(
                                new CollectionGene( geneNode.@propName.toString(), collection,
                                Number( geneNode.@mutationEffect.toString() ),
                                geneNode.@limitMethod.toString(), Number( geneNode.@baseValue.toString() ) )
                                );
                    break;
                }
            }

            return this;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get genes():Vector.<Gene>
        {
            return _genes;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}