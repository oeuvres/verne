<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- Index footnote items by xml:id -->
  <xsl:key name="note"
           match="tei:item[@xml:id]"
           use="@xml:id"/>

  <!-- Identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Replace footnote references by TEI <note> -->
  <xsl:template match="tei:ref[starts-with(@target, '#cite_note-')]">
    <xsl:variable name="id" select="substring(@target, 2)"/>
    <xsl:variable name="item" select="key('note', $id)"/>

    <xsl:choose>
      <xsl:when test="$item">
        <note xmlns="http://www.tei-c.org/ns/1.0">
          <xsl:apply-templates
              select="$item/tei:seg[contains(concat(' ', @rend, ' '),
                                            ' reference-text ')]/node()"/>
        </note>
      </xsl:when>

      <!-- Keep unresolved refs unchanged -->
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Remove the original footnote lists -->
  <xsl:template match="tei:list[
      tei:item[starts-with(@xml:id, 'cite_note-')]
    ]"/>

</xsl:stylesheet>