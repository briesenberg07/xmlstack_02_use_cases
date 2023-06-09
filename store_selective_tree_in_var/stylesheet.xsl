<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">

    <!--<xsl:output method="html" indent="yes"/>-->
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="institution" select="'WAU'"/>
        <xsl:variable name="resource" select="'rdaEntity'"/>
        <xsl:variable name="format" select="'test'"/>
        <xsl:variable name="user" select="'ries07'"/>
        <xsl:variable name="rt_id">{concat('UWSINOPIA:', $institution, ':', $resource, ':', $format,
            ':', $user)}</xsl:variable>
        <xsl:variable name="prop_info" as="node()*">
            <xsl:for-each select="
                    document('source.xml')/uwmaps:prop_set/uwmaps:prop
                    [uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]]">
                <xsl:sort select="
                        uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:form_order"/>
                <xsl:element name="prop" namespace="https://uwlib-cams.github.io/map_storage/xsd/">
                    <xsl:copy-of select="uwmaps:prop_iri"/>
                    <xsl:copy-of select="uwmaps:prop_label"/>
                    <!-- skip some prop info -->
                    <xsl:element name="sinopia"
                        namespace="https://uwlib-cams.github.io/map_storage/xsd/">
                        <xsl:element name="toolkit"
                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                            <xsl:attribute name="url"
                                >{uwmaps:sinopia/uwsinopia:toolkit/@url}</xsl:attribute>
                        </xsl:element>
                        <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set">
                            <xsl:element name="guidance_set">
                                <xsl:if
                                    test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general">
                                    <xsl:element name="general">
                                        <xsl:choose>
                                            <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general
                                                    [@rt_id = $rt_id]">
                                                <xsl:copy-of copy-namespaces="no" select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set
                                                        /uwsinopia:general[@rt_id = $rt_id]/node()"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of copy-namespaces="no" select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set
                                                        /uwsinopia:general[@rt_id = 'default']/node()"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                        <xsl:copy-of select="
                                uwmaps:sinopia/uwsinopia:implementation_set
                                [uwsinopia:institution = $institution]
                                [uwsinopia:resource = $resource]
                                [uwsinopia:format = $format]
                                [uwsinopia:user = $user]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$prop_info"/>
    </xsl:template>

</xsl:stylesheet>
