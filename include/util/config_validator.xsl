<?xml version="1.0" encoding="UTF-8"?>

<!--
    This file auto-generates a class derived from util::validator that
    implements an init() method, which populates configuration options
    from the XML specification file supplied by an app developer.
     
    Copyright (c) 2012 Sergey Aleynikov <saleyn@gmail.com>
    Created: 2012-01-12
-->
     
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output indent="yes" method="text" encoding="us-ascii"/>

<xsl:param name="now"/>
<xsl:param name="author"/>
<xsl:param name="email">saleyn@gmail.com</xsl:param>
<xsl:param name="file"/>

<!-- Setup the basic HTML skeleton -->
<xsl:template match="/config"><xsl:variable name="ifdef">
    <xsl:call-template name="def-name"/>
</xsl:variable>
//------------------------------------------------------------------------------
<xsl:if test="$file">
    <xsl:text>// </xsl:text><xsl:value-of select="$file"/>
</xsl:if>
// This file is auto-generated by "util/config_validator.xsl".
//
// *** DON'T MODIFY BY HAND!!! ***
//
<xsl:if test="$author">
    <xsl:text>// Copyright (c) 2012 </xsl:text><xsl:value-of select="$author"/>
    <xsl:if test="$email">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$email"/>
        <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>
</xsl:text>
</xsl:if>
// Created: <xsl:value-of select="$now"/>
//------------------------------------------------------------------------------

#ifndef <xsl:value-of select="$ifdef"/>
#define <xsl:value-of select="$ifdef"/>

#include &lt;util/config_validator.hpp&gt;

namespace <xsl:value-of select="@namespace"/> {
    using namespace util::config;
    using util::variant;
    using util::config::option;
    namespace {
        typedef option_vector ovec;
        typedef string_set    sset;
        typedef variant_set   vset;
    }

    struct <xsl:value-of select="@name"/> : public validator {
        <xsl:value-of select="@name"/>() { init(); }
<xsl:text>
        void init() {
            clear();
</xsl:text>
            <xsl:call-template name="process_options">
                <xsl:with-param name="level">0</xsl:with-param>
                <xsl:with-param name="arg">m_options</xsl:with-param>
            </xsl:call-template>
<xsl:text>        }
    };
} // namespace </xsl:text><xsl:value-of select="@namespace"/>

#endif // <xsl:value-of select="$ifdef"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="process_options">
    <xsl:param name="level"/>
    <xsl:param name="arg"/>
    
    <xsl:variable name="ws"><xsl:call-template name="pad">
        <xsl:with-param name="n" select="$level+6"/>
    </xsl:call-template></xsl:variable>

    <xsl:variable name="ws2"><xsl:call-template name="pad">
        <xsl:with-param name="n" select="$level+1+6"/>
    </xsl:call-template></xsl:variable>

    <xsl:variable name="ws4">
        <xsl:call-template name="pad">
            <xsl:with-param name="n" select="$level+2+6"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:for-each select="option | include">
        <xsl:choose>
            <xsl:when test="self::node()[self::option]">
                <xsl:value-of select="$ws"/><xsl:text>{
</xsl:text>
                <xsl:value-of select="$ws2"/>ovec l_children<xsl:value-of select="$level"/><xsl:text>; sset l_names; vset l_values;
</xsl:text>
            <xsl:call-template name="process_options">
                <xsl:with-param name="level" select="$level+1"/>
                <xsl:with-param name="arg" select="concat('l_children',$level)"/>
            </xsl:call-template>
            
            <xsl:for-each select="values/name">
                <xsl:value-of select="$ws2"/><xsl:text>l_names.insert("</xsl:text>
                <xsl:value-of select="@val"/>
                <xsl:text>");
</xsl:text>
            </xsl:for-each>

            <xsl:for-each select="values/value">
                <xsl:value-of select="$ws2"/><xsl:text>l_values.insert(variant(</xsl:text>
                <xsl:call-template name="value-to-string">
                    <xsl:with-param name="value" select="@val"/>
                    <xsl:with-param name="type" select="../../@val_type"/>
                </xsl:call-template>
                <xsl:text>));
</xsl:text>
            </xsl:for-each>

            <xsl:value-of select="$ws2"/><xsl:value-of select="$arg"/><xsl:text>.push_back(
</xsl:text> <xsl:value-of select="$ws4"/>option("<xsl:value-of select="@name"/><xsl:text>", </xsl:text>
                <xsl:choose>
                    <xsl:when test="@type">
                        <xsl:call-template name="string-to-type">
                            <xsl:with-param name="name" select="@name"/>
                            <xsl:with-param name="kind" select="'type_of_name'"/>
                            <xsl:with-param name="type" select="@type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><xsl:text>STRING</xsl:text></xsl:otherwise>
                </xsl:choose>
                <xsl:text>, </xsl:text>
                <xsl:call-template name="string-to-type">
                    <xsl:with-param name="name" select="@name"/>
                    <xsl:with-param name="kind" select="'type_of_value'"/>
                    <xsl:with-param name="type" select="@val_type"/>
                </xsl:call-template>
                <xsl:text>, "</xsl:text><xsl:value-of select="@desc"/><xsl:text>", </xsl:text>
                <xsl:choose>
                    <xsl:when test="@unique">
                        <xsl:value-of select="@unique"/>
                    </xsl:when>
                    <xsl:otherwise>true</xsl:otherwise>
                </xsl:choose>
                <xsl:text>,
</xsl:text>     <xsl:value-of select="$ws4"/><xsl:text>  </xsl:text>
                <xsl:choose>
                    <xsl:when test="@default">
                        <xsl:text>variant(</xsl:text>
                        <xsl:call-template name="value-to-string">
                            <xsl:with-param name="value" select="@default"/>
                            <xsl:with-param name="type" select="@val_type"/>
                        </xsl:call-template>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise><xsl:text>variant()</xsl:text></xsl:otherwise>
                </xsl:choose>
                <xsl:text>, </xsl:text>
                <xsl:choose>
                    <xsl:when test="@min">
                        <xsl:text>variant(</xsl:text>
                        <xsl:value-of select="@min"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise><xsl:text>variant()</xsl:text></xsl:otherwise>
                </xsl:choose>
                <xsl:text>, </xsl:text>
                <xsl:choose>
                    <xsl:when test="@max">
                        <xsl:text>variant(</xsl:text>
                        <xsl:value-of select="@max"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise><xsl:text>variant()</xsl:text></xsl:otherwise>
                </xsl:choose>
                <xsl:text>, l_names, l_values, l_children</xsl:text>
                <xsl:value-of select="$level"/><xsl:text>));
</xsl:text>     <xsl:value-of select="$ws"/><xsl:text>}
</xsl:text>
            </xsl:when>
            <xsl:when test="self::node()[self::include]">
                <xsl:variable name="inc" select="document(@file)"/>
                <xsl:for-each select="$inc">
                    <xsl:call-template name="process_options">
                        <xsl:with-param name="level" select="$level"/>
                        <xsl:with-param name="arg" select="concat('l_children',$level - 1)"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>

<xsl:template name="value-to-string">
    <xsl:param name="value"/>
    <xsl:param name="type"/>
    <xsl:choose>
        <xsl:when test="$type = 'string'">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$value"/>
            <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="string-to-type">
    <xsl:param name="name"/>
    <xsl:param name="kind"/>
    <xsl:param name="type"/>
    <xsl:choose>
        <xsl:when test="$type = 'string'"><xsl:text>STRING</xsl:text></xsl:when>
        <xsl:when test="$type = 'int'"><xsl:text>INT</xsl:text></xsl:when><xsl:when test="$type = 'bool'">BOOL</xsl:when>
        <xsl:when test="$type = 'float'"><xsl:text>FLOAT</xsl:text></xsl:when>
        <xsl:when test="$type = 'anonymous'"><xsl:text>ANONYMOUS</xsl:text></xsl:when>
        <xsl:otherwise>
            <xsl:message terminate="yes">
                ERROR: undefined <xsl:value-of select="$kind"/> of option: <xsl:value-of select="$name"/>
            </xsl:message>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="pad">
    <xsl:param name="n" select="0"/>
    <xsl:if test="$n &gt; 0">
        <xsl:text>  </xsl:text>
        <xsl:call-template name="pad">
            <xsl:with-param name="n" select="number($n) - 1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="def-name">_AUTOGEN_<xsl:value-of
    select="translate(concat(@namespace, '_', @name),
	              'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
    />_HPP_</xsl:template>
        
</xsl:stylesheet>
