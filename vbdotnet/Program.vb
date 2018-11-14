'    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
'   
'    copyright (C) 2018  Eric Gagné, Lachine, Qc
'
'    This program is free software: you can redistribute it and/or modify
'    it under the terms of the GNU General Public License as published by
'    the Free Software Foundation, either version 3 of the License, or
'    (at your option) any later version.'

'    This program is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU General Public License for more details.
'
'    You should have received a copy of the GNU General Public License
'    along with this program.  If not, see <https://www.gnu.org/licenses/>.


' Ne modifiez pas ce fichier
' Juste pour être clair, ça veut dire qu'il faut pas modifiez ce ficheir.
' Mais au cas ou ce serait toujours pas clair
' CE FICHIER NE DOIT PAS ÊTRE MODIFIÉ !


Imports System.IO
Imports System.Data
Imports System.String

Module Module1

    Sub Main()

        Dim myXMLfile As String = "/mnt/d/qosm/geodata/lieux_d_accueil.xml"
        Dim ds As New DataSet()
        Dim xmlds As New DataSet()

        Dim fsReadXml As New System.IO.FileStream(myXMLfile, System.IO.FileMode.Open)
        Try
            xmlds.ReadXml(fsReadXml, XmlReadMode.InferSchema)
        Catch ex As Exception
            Console.WriteLine(ex.ToString())
            Console.WriteLine(myXMLfile)
            Console.ReadLine()
        Finally
            fsReadXml.Close()
        End Try

        ProcessTable(xmlds.Tables("etablissement"), "/mnt/d/qosm/geodata/etablissement.csv")
        ProcessTable(xmlds.Tables("adresses"), "/mnt/d/qosm/geodata/adresses.csv")
        ProcessTable(xmlds.Tables("adresse"), "/mnt/d/qosm/geodata/adresse.csv")
        ProcessTable(xmlds.Tables("etbl_types"), "/mnt/d/qosm/geodata/etbl_types.csv")
        ProcessTable(xmlds.Tables("etbl_type"), "/mnt/d/qosm/geodata/etbl_type.csv")
        ProcessTable(xmlds.Tables("contacts"), "/mnt/d/qosm/geodata/contacts.csv")
        ProcessTable(xmlds.Tables("contact"), "/mnt/d/qosm/geodata/contact.csv")
        ProcessTable(xmlds.Tables("caracteristiques"), "/mnt/d/qosm/geodata/caracteristiques.csv")
        ProcessTable(xmlds.Tables("caracteristique"), "/mnt/d/qosm/geodata/caracteristique.csv")
        ProcessTable(xmlds.Tables("caract_attributs"), "/mnt/d/qosm/geodata/caract_attributs.csv")
        ProcessTable(xmlds.Tables("caract_attribut"), "/mnt/d/qosm/geodata/caract_attribut.csv")

    End Sub

    Public Sub ProcessTable(ByVal dTable As DataTable, ByVal csvName As String)
        Dim csvwriter As New StreamWriter(csvName)
        Dim csvstring As String = ""

        For Each c As DataColumn In dTable.Columns
            csvstring = String.Format("{0}`{1}`|", csvstring, c.ColumnName)
        Next
        csvwriter.WriteLine(csvstring.substring(0,csvstring.length-1))

        For Each row As DataRow In dTable.Rows
            csvstring = ""
            For Each c As DataColumn In dTable.Columns
                csvstring = String.Format("{0}`{1}`|", csvstring, row(c.ColumnName).ToString)
            Next
	    csvwriter.WriteLine(csvstring.substring(0,csvstring.length-1))
        Next
        csvwriter.Close()
        csvwriter.Dispose()

    End Sub


End Module
