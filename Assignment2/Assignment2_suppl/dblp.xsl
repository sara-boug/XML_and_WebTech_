<?xml version="1.0" encoding="utf-8"?>
<!-- Created with Liquid Studio 2021 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="dblp">
         <xsl:for-each-group select="*" group-by="author">
            <author>
                <xsl:value-of select="current-grouping-key()"/>
               <publications>
                <xsl:for-each-group select="current-group()" group-by="year">
                    <year>
                        <xsl:value-of select="current-grouping-key()"/>
                    </year>
                    <xsl:for-each select="current-group()">
                        <h1>
                            <xsl:value-of select="title"/>
                            <xsl:copy-of select="author">  </xsl:copy-of>
                        </h1>
                        <h1>
                            <xsl:value-of select="booktitle"/>
                            <xsl:copy-of select="author">  </xsl:copy-of>
                        </h1>
                    </xsl:for-each>
            </xsl:for-each-group>
            </publications>
          </author>
             
        </xsl:for-each-group>
        
     </xsl:template>


    <xsl:template name="auth" match="author">
        
        <xsl:param name="author"/>
        <joint>
        <xsl:copy-of select="author|title|booktitle">  </xsl:copy-of>
        </joint>      
    </xsl:template>
    <xsl:template name="joint" match="title|booktitle">
        <pub>
        <xsl:copy-of select="title">  </xsl:copy-of>
        <xsl:copy-of select="booktitle">  </xsl:copy-of>

        </pub>
    </xsl:template>
    </xsl:stylesheet>


