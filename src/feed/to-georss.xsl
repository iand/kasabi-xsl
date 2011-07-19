<!--

This stylesheet allows the SPARQL XML Results format to be transformed into a simple GeoJRSS
file. 

http://www.georss.org/
 
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
relevant GeoRSS entry

XSLT PARAMETERS

None

 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	version="1.0" 
	exclude-result-prefixes="xsl sparql rdf">

	<xsl:output 
		indent="yes" 
		method="xml" 
		media-type="application/xml"/>

	<xsl:param name="title"/>
	<xsl:param name="description"/>
    
	<xsl:template match="sparql:sparql">
    <rss version="2.0" xmlns:georss="http://www.georss.org/georss" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
      <channel>
        <title>
          <xsl:choose>
            <xsl:when test="$title"><xsl:value-of select="$title"/></xsl:when>
            <xsl:otherwise><xsl:text>SPARQL Query Results</xsl:text></xsl:otherwise>
          </xsl:choose>
        </title>
        <description>
          <xsl:choose>
            <xsl:when test="$description"><xsl:value-of select="$description"/></xsl:when>
            <xsl:otherwise><xsl:text>SPARQL Query Results</xsl:text></xsl:otherwise>
          </xsl:choose>
        </description>
        <xsl:for-each select="sparql:results/sparql:result">
          <item>
            <title>
              <xsl:choose>
                <xsl:when test="sparql:binding[@name='title']"><xsl:value-of select="normalize-space(sparql:binding[@name='title'])"/></xsl:when>
                <xsl:otherwise><xsl:text>Point</xsl:text></xsl:otherwise>
              </xsl:choose>
            </title>
            <xsl:if test="sparql:binding[@name='id']">
              <id>  
                <xsl:value-of select="normalize-space(sparql:binding[@name='id'])"/>
              </id>
            </xsl:if>
            <georss:point>
              <xsl:value-of select="normalize-space(sparql:binding[@name='lat'])"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(sparql:binding[@name='long'])"/>
            </georss:point>          
            <geo:lat>
              <xsl:value-of select="normalize-space(sparql:binding[@name='lat'])"/>
            </geo:lat>          
            <geo:long>
              <xsl:value-of select="normalize-space(sparql:binding[@name='long'])"/>
            </geo:long>          
          </item>
        </xsl:for-each>      
      </channel>
    </rss>
	</xsl:template>

</xsl:stylesheet>
