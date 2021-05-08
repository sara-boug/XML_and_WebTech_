<?xml version="1.0" encoding="utf-8"?>
<!-- Created with Liquid Studio 2021 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <?xml-stylesheet type="text/css" href="style.css"?>


    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="dblp">
        <xsl:for-each-group select="*" group-by="author">
            <!--  storing the grouping key in a variable-->
            <!-- a variable to store the author name  -->
            <xsl:variable name="title" select="current-grouping-key()"></xsl:variable>
            <!--  performing the extraction  -->
            <!-- It is assumed that first and last name are separated by space -->
            <xsl:variable name="firstName"  select="substring-before($title,' ')"></xsl:variable>
            <xsl:variable name="lastName"  select="substring-after($title,' ')"></xsl:variable>
            <xsl:variable name="letter"  select="substring($lastName,1,1)"></xsl:variable>
            <xsl:result-document href="a-tree/{$letter}/{$lastName}.{$firstName}.html">
                <html>
                    <head>
                        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
                        <style> <!-- Simple Styling -->
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
                        <h1>
                            <xsl:value-of select="$title"/>
                        </h1>
                        <!-- the counter i -->
                        <table>
                             <!-- Counting the number of publications of the author -->

                            <xsl:for-each-group select="current-group()" group-by="year">

                                <xsl:sort select="current-grouping-key()"></xsl:sort>


                                <tr>
                                    <th colspan="3">
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </th>
                                </tr>
                                <!-- row enumeration -->
                                 <xsl:for-each-group select="current-group()" group-by="title">

                                     <xsl:sort select="current-grouping-key()"></xsl:sort>
                                     <!-- in order to get the number of elements -->
                                     <xsl:variable name="c" select="last()+1"></xsl:variable>
                                     <xsl:variable name="n" select="$c - position()"></xsl:variable>


                                     <tr>
                                        <td>
                                            <a>
                                                <xsl:attribute name="name">
                                                    <xsl:value-of select="title"></xsl:value-of>
                                                </xsl:attribute>
                                                <!-- Position-->
                                                    <xsl:value-of select="$n"></xsl:value-of>
                                             </a>
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
                                            <xsl:for-each-group select="current-group()" group-by="author">
                                                <xsl:call-template name="link">
                                                    <xsl:with-param name="authorParam" select="current-grouping-key()"></xsl:with-param>
                                                    <xsl:with-param name="title" select="$title"></xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:for-each-group>
                                            , <xsl:value-of select="current-grouping-key()"/>
                                        </td>
                                    </tr>
                                </xsl:for-each-group>

                            </xsl:for-each-group>
                        </table>

                        <!-- Coauthors table  -->
                        <h2> Coauthors</h2>
                        <table>
                            <xsl:for-each-group select="current-group()" group-by="title">
                                <xsl:sort select="author"></xsl:sort>
                                <xsl:variable name="c" select="last()+1"></xsl:variable>
                                <xsl:variable name="n" select="$c - position()"></xsl:variable>
                                <xsl:for-each-group select="current-group()" group-by="author">
                                    <tr>
                                        <td>
                                            <xsl:call-template name="link">
                                                <xsl:with-param name="authorParam" select="current-grouping-key()"></xsl:with-param>
                                                <xsl:with-param name="title" select="$title"></xsl:with-param>
                                            </xsl:call-template>
                                        </td>
                                        <td>
                                            [<a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('#',current-grouping-key())"></xsl:value-of>
                                                </xsl:attribute>
                                                     <xsl:value-of select="$n"></xsl:value-of>
                                              </a>]
                                        </td>
                                    </tr>
                                </xsl:for-each-group>
                            </xsl:for-each-group>
                        </table>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each-group>

        <!-- XSL template to extract the link from author  -->
    </xsl:template>
    <xsl:template name="link">
        <xsl:param name="authorParam"></xsl:param>
        <xsl:param name="title"></xsl:param>

        <xsl:variable name="author" select="$authorParam"></xsl:variable>
        <xsl:if test="not($title = $author)">
            <xsl:variable name="firstName"  select="substring-before($author,' ')"></xsl:variable>
            <xsl:variable name="lastName"  select="substring-after($author,' ')"></xsl:variable>
            <xsl:variable name="letter"  select="substring($lastName,1,1)"></xsl:variable>
            <a href="..\{$letter}\{$lastName}.{$firstName}.html">
                <xsl:value-of select="$author"></xsl:value-of> ,
            </a>
        </xsl:if>
        <xsl:if test="($title = $author)">
            <xsl:value-of select="$author"></xsl:value-of> ,
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>


