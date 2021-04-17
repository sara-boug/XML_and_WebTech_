<?xml version="1.0" encoding="utf-8"?>
<!-- Created with Liquid Studio 2021 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <?xml-stylesheet type="text/css" href="style.css"?>


    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="dblp">
        <html>
            <head>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
                <style>
                    table,td {
                    border: 1px solid #333;
                    }
                    thead,tfoot {
                    background-color: #333;
                    color: #fff;
                    }
                </style>

            </head>
            <body>
                <xsl:for-each-group select="*" group-by="author">
                    <h1>
                        <xsl:value-of select="current-grouping-key()"/>
                    </h1>
                    <table>
                        <!-- the counter i -->
                        <xsl:for-each-group select="current-group()" group-by="year">
                            <xsl:sort select="current-grouping-key()"></xsl:sort>
                            <tr>
                                <th colspan="3">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </th>
                            </tr>
                            <xsl:variable name="c" select="count(current-group())+1"></xsl:variable>

                            <xsl:for-each select="current-group()">
                                <xsl:sort select="author"></xsl:sort>
                                <tr>
                                    <td>
                                         <xsl:value-of select="$c - position()"></xsl:value-of>
                                    </td>
                                    <td>
                                        <a>
                                            <xsl:if test="ee">
                                                <!-- Checking the existence of the ee link  -->
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="ee"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <i class="fa fa-list"/>
                                        </a>
                                    </td>
                                    <td>
                                        <xsl:copy-of select="author"></xsl:copy-of>,
                                        <xsl:value-of select="title"/>
                                    </td>
                                </tr>
                            </xsl:for-each>

                        </xsl:for-each-group>
                    </table>

                </xsl:for-each-group>
            </body>
        </html>
    </xsl:template>



    <xsl:template name="counter" >
        <xsl:param name="i"/>
        <xsl:param name="stop"/>
        <xsl:call-template name="counter">
            <xsl:with-param name="i" select="$i+1"></xsl:with-param>
        </xsl:call-template>
                <xsl:value-of select="$i"></xsl:value-of>
     </xsl:template>


    <xsl:template name="year">
 
    </xsl:template>
</xsl:stylesheet>


