<!--

This stylesheet allows the SPARQL XML Results format to be transformed into a simple GeoJSON
file. 

 http://geojson.org/geojson-spec.html
 
Currently the transform will only handle the generation of lists of Point Features.

QUERY FORMATTING

The stylesheet expects the SPARQL query results to be constructed in a specific way. This allows 
the stylesheet to reliably extract some required fields from the query results. A SPARQL select 
query returns a number results (rows) that each have some named bindings (columns). The stylesheet 
uses the following named bindings in order to construct the output:

* id - the identifier for a Feature. Optional
* lat - latitude of the placemark. Required.
* long - longitude of the placemark. Required.

All other bindings present in the results will be automatically turned into properties of the 
relevant GeoJSON feature.

XSLT PARAMETERS

None

 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:kml="http://www.opengis.net/kml/2.2" 
	xmlns="http://www.opengis.net/kml/2.2" 
	version="1.0" 
	exclude-result-prefixes="sparql rdf kml">

  <xsl:output 
  	method="text" 
  	omit-xml-declaration="yes"/>
  <xsl:strip-space 
  	elements="sparql:binding sparql:literal sparql:uri" />
    
	<xsl:template match="sparql:sparql">{ "type": "FeatureCollection",
  "features": [
    <xsl:for-each select="sparql:results/sparql:result">
     { "type": "Feature",
       "properties":{
         <xsl:for-each select="sparql:binding[@name != 'id' and @name!='long' and @name!='lat']">
         	"<xsl:value-of select="@name"/>" : "<xsl:value-of select="."/>"
      	    <xsl:if test="position()!=last()">,</xsl:if><xsl:if test="position()=last()"><xsl:text>&#10;</xsl:text></xsl:if>         	
         </xsl:for-each>
       },
       <xsl:if test="sparql:binding[@name='id']">
       "id": "<xsl:value-of select="sparql:binding[@name='id']"/>",
       </xsl:if> 
       "geometry": {
          "type": "Point", 
          "coordinates": [<xsl:value-of select="sparql:binding[@name='long']/sparql:literal"/><xsl:text>,</xsl:text><xsl:value-of select="sparql:binding[@name='lat']/sparql:literal"/>] 
        } 
      }
      <xsl:if test="position()!=last()">,</xsl:if><xsl:if test="position()=last()"><xsl:text>&#10;</xsl:text></xsl:if> 
    </xsl:for-each>      
  ]
}	
	</xsl:template>

</xsl:stylesheet>