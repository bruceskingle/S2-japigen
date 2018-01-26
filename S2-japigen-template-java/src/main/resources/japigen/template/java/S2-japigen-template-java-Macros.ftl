<#------------------------------------------------------------------------------------------------------
 # 
 # This is the master definition of what the variables defined in macros mean.
 # ===========================================================================
 #
 #
 # Defined by the model:
 # ---------------------
 # javaModel.name                  Name as defined in the openApi3 input spec
 #
 # javaModel.camelName             Name in camel case with a lower case first letter
 #
 # javaModel.camelCapitalizedName  Name in camel case with an upper case first letter
 #
 # javaModel.snakeName             Name in snake case with a lower case first letter
 #
 # javaModel.snakeCapitalizedName  Name in snake case with an upper case first letter 
 #
 # javaModel.elementType           The type of the parse tree element
 #
 #
 #
 # Defined by setJavaType macro:
 # -----------------------------
 # javaClassName                   Name of the Java class to be referred to from other code
 #
 # javaFullyQualifiedClassName     Fully qualified name of the Java class to be referred to from other
 #                                 code for imports NOT SET for non-imported types like String
 #
 # javaFieldClassName              Name of Java class for the field inside a generated class
 #  
 # javaElementClassName            Name of Java class for the the elements of a collection. For
 #                                 non-collection types this is the same as javaFieldClassName
 #  
 # isExternal                      Boolean is true for external types otherwise false
 #  
 # requiresChecks                  Boolean is true for fields of generated types otherwise false
 #  
 # javaTypeCopy(X)                 Prefix-Postfix to make an immutable copy of collections for object
 #                                 fields. Both empty strings in other cases.
 #  
 # javaBuilderTypeCopy(X):         Prefix-Postfix to make a mutable copy of collections for object
 #                                 builders. Both empty strings in other cases.
 #
 # javaGetValue(X):                Prefix-Postfix to get the value object from a generated typedef
 #                                 when referring to it. Both empty strings in other cases.
 #  
 # javaConstructType(X):           Prefix-Postfix to construct an instance of a generated typedef from
 #                                 a value object. Both empty strings in other cases.
 #
 # javaBuilderTypeNew:             Constructor for an empty collection for a builder.
 #  
 # addJsonNode:                    Method name to add an element to the JsonNode for an object
 #  
 # javaCardinality:                Cardinality of a collection, List or Set
 #
 # A subset of these values with the prefix "model" are set for the main model by setModelJavaType.
 #----------------------------------------------------------------------------------------------------->

<#macro printModel>
/* *****************************************************************************************************
 * Model ${javaModel}
 *    name                               ${javaModel.name}
 *    camelName                          ${javaModel.camelName}
 *    camelCapitalizedName               ${javaModel.camelCapitalizedName}
 *    snakeName                          ${javaModel.snakeName}
 *    snakeCapitalizedName               ${javaModel.snakeCapitalizedName}
 *    elementType                        ${javaModel.elementType}
 *    canFailValidation                  ${javaModel.canFailValidation?c}
 *
 *    modelJavaClassName                 ${modelJavaClassName!"NULL"}
 *    modelJavaFullyQualifiedClassName   ${modelJavaFullyQualifiedClassName!"NULL"}
 *    modelJavaFieldClassName            ${modelJavaFieldClassName!"NULL"}
 *    modelJavaElementClassName          ${modelJavaElementClassName!"NULL"}
 *    modelJavaCardinality               ${modelJavaCardinality}
 *    modelIsGenerated                   ${modelIsGenerated?c}
 * ****************************************************************************************************/
</#macro>

<#macro printField>
/* ====================================================================================================
 * Field ${javaField}
 *    field.name                    ${javaField.name}
 *    field.camelName               ${javaField.camelName}
 *    field.camelCapitalizedName    ${javaField.camelCapitalizedName}
 *    field.snakeName               ${javaField.snakeName}
 *    field.snakeCapitalizedName    ${javaField.snakeCapitalizedName}
 *    field.elementType             ${javaField.elementType}
 *    field.description             ${javaField.description!"NULL"}
 *    field.baseSchema              ${javaField.baseSchema}
 *    field.elementSchema           ${javaField.elementSchema}
 *    field.canFailValidation       ${javaField.canFailValidation?c}
 *    field.format                  ${javaField.format!"NULL"}
 *    field.hasByteString           ${javaField.hasByteString?c}
 *    field.hasCollections          ${javaField.hasCollections?c}
 *    field.hasList                 ${javaField.hasList?c}
 *    field.hasSet                  ${javaField.hasSet?c}
 *    field.isArraySchema           ${javaField.isArraySchema?c}
 *    field.isObjectSchema          ${javaField.isObjectSchema?c}
 *    field.isComponent             ${javaField.isComponent?c}
 *    field.isTypeDef               ${javaField.isTypeDef?c}
 *
 *    javaClassName                 ${javaClassName!"NULL"}
 *    javaFullyQualifiedClassName   ${javaFullyQualifiedClassName!"NULL"}
 *    javaFieldClassName            ${javaFieldClassName!"NULL"}
 *    javaElementClassName          ${javaElementClassName!"NULL"}
 *    isGenerated                   ${isGenerated?c}
 *    isExternal                    ${isExternal?c}
 *    requiresChecks                ${requiresChecks?c}
 *    javaTypeCopy(X)               ${javaTypeCopyPrefix}X${javaTypeCopyPostfix}
 *    javaBuilderTypeCopy(X)        ${javaBuilderTypeCopyPrefix}X${javaBuilderTypeCopyPostfix}
 *    javaGetValue(X)               ${javaGetValuePrefix}X${javaGetValuePostfix}
 *    javaConstructType(X)          ${javaConstructTypePrefix}X${javaConstructTypePostfix}
 *    javaBuilderTypeNew            ${javaBuilderTypeNew}
 *    addJsonNode                   ${addJsonNode}
 *    javaCardinality               ${javaCardinality}
 * ==================================================================================================*/
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro is called only from the template prologue. It calls setModelJavaType and if debug is
 # enabled it prints information about the model and all its fields in a comment.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setPrologueJavaType model>
<@setModelJavaType model/>
<#if templateDebug??>
<@printModel/>
</#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro sets a list of variables for the main model element in a template.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setModelJavaType model>
  <#assign javaModel=model>
  <#assign modelJavaFieldClassName="">
  <#assign modelJavaElementClassName="">
  <#assign modelJavaCardinality="">
  <#-- 
   #
   # First set modelJavaClassName, modelJavaFullyQualifiedClassName, and modelIsGenerated
   #
   #-->
  <#if model.attributes['javaExternalType']??>
    <#assign modelJavaClassName=model.attributes['javaExternalType']>
    <#assign modelJavaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${modelJavaClassName}">
    <#assign modelIsGenerated=false>
  <#else>
    <#assign modelJavaClassName=model.camelCapitalizedName>
    <#assign modelJavaFullyQualifiedClassName="${javaFacadePackage}.${modelJavaClassName}">
    <#assign modelIsGenerated=true>
  </#if>
  <#-- 
   #
   # Set javaElementClassName which is the basic Java type which stores simple values.
   #
   #-->
  <#assign modelJavaElementClassName=getJavaClassName(model.elementSchema)/>
  <#-- 
   #
   # now set modelJavaFieldClassName and decorator attributes
   #
   #-->
  <#assign modelJavaFieldClassName=getJavaClassName(model.baseSchema)/>
  <#if model.isArraySchema>
    <#switch model.baseSchema.cardinality>
      <#case "SET">
        <#assign modelJavaCardinality="Set">
        <#break>
        
      <#default>
        <#assign modelJavaCardinality="List">
    </#switch>
  <#else>
    <#assign modelJavaCardinality="">
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro sets a list of variables based on the given field modelElement. This is simply a way of 
 # avoiding copies of this logic in multiple templates.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setJavaType model>
  <#assign javaField=model>
  <#assign javaClassName="">
  <#assign javaFullyQualifiedClassName="">
  <#assign javaGeneratedBuilderClassName="">
  <#assign javaGeneratedBuilderFullyQualifiedClassName="">
  <#assign javaFieldClassName="">
  <#assign javaElementClassName="">
  <#assign javaTypeCopyPrefix="">
  <#assign javaTypeCopyPostfix="">
  <#assign javaBuilderTypeCopyPrefix=" = ">
  <#assign javaBuilderTypeCopyPostfix="">
  <#assign javaGetValuePrefix="">
  <#assign javaGetValuePostfix="">
  <#assign javaConstructTypePrefix="">
  <#assign javaConstructTypePostfix="">
  <#assign javaBuilderTypeNew="">
  <#assign addJsonNode="addIfNotNull">
  <#assign isGenerated=false>
  <#assign isExternal=false>
  <#assign requiresChecks=true>
  <#assign javaCardinality="">
  <#-- 
   #
   # first set javaElementClassName which is the basic Java type which stores simple values.
   #
   #-->
  <#assign javaElementClassName=getJavaClassName(model.elementSchema)/>
  <#-- 
   #
   # now set javaFieldClassName
   #
   #-->
  <#assign javaFieldClassName=getJavaClassName(model.baseSchema)/>
  <#-- 
   #
   # now set the javaClassName
   #
   #-->
  <@setClassName model javaFieldClassName/>
  <#-- 
   #
   # now set decorator attributes
   #
   #-->
   <@decorate model/>
   <@setDescription model/>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # return the Java class name for the given Schema
 #
 # @param Schema model     A Schema for which the java class name is required.
 #----------------------------------------------------------------------------------------------------->
<#function getJavaClassName model>
  <#if model.isArraySchema>
    <#switch model.cardinality>
      <#case "SET">
        <#return "Set<${getJavaClassName(model.elementSchema)}>">
        
      <#default>
        <#return "List<${getJavaClassName(model.elementSchema)}>">
    </#switch>
  </#if>
  <#switch model.elementType>
    <#case "Integer">
      <#switch model.format>
        <#case "int32">
          <#return "Integer">
          
         <#default>
          <#return "Long">
      </#switch>
      
    <#case "Double">
      <#switch model.format>
        <#case "float">
          <#return "Float">
        
        <#default>
          <#return "Double">
      </#switch>
    
    <#case "String">
      <#switch model.format>
        <#case "byte">
          <#return "ByteString">
        
        <#default>
          <#return "String">
      </#switch>
    
    <#case "Boolean">
      <#return "Boolean">
    
    <#default>
      <#return "${model.camelCapitalizedName}">
  </#switch>
</#function>

<#------------------------------------------------------------------------------------------------------
 # Does the Java class for the given Schema implement Comparable<>
 #
 # @param Schema model     A Schema for which the java class name is required.
 #----------------------------------------------------------------------------------------------------->
<#function isComparable model>
  <#switch model.baseSchema.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "Boolean">
      <#return true>

    
    <#case "String">
      <#switch model.baseSchema.format>
        <#case "byte">
          <#return false>
        
        <#default>
          <#return true>
      </#switch>
    
    
    <#default>
      <#return false>
  </#switch>
</#function>

<#macro setDescription model>
  <#switch model.elementType>
    <#case "Ref">
      <@setDescription model.reference/>
      <#break>

    <#case "Field">
      <@setDescription model.type/>
      <#break>
    
    <#default>
      <#assign description=model.description!"">
      <#assign summary=model.summary!"No summary given.">
  </#switch>
</#macro>

<#macro decorateArray model>
  <#if model.items.baseSchema.isObjectSchema>
    <#assign addJsonNode="addCollectionOfDomNode">
  <#else>
    <#assign addJsonNode="addCollectionOf${javaElementClassName}">
  </#if>
  <#assign javaTypeCopyPostfix=")">
  <#assign javaBuilderTypeCopyPostfix=")">
  <#switch model.cardinality>
    <#case "SET">
      <#assign javaCardinality="Set">
      <#assign javaTypeCopyPrefix="ImmutableSet.copyOf(">
      <#assign javaBuilderTypeCopyPrefix=".addAll(">
      <#assign javaBuilderTypeNew=" = new HashSet<>()">
      <#break>
      
    <#default>
      <#assign javaCardinality="List">
      <#assign javaTypeCopyPrefix="ImmutableList.copyOf(">
      <#assign javaBuilderTypeCopyPrefix=".addAll(">
      <#assign javaBuilderTypeNew=" = new LinkedList<>()">
  </#switch>
</#macro>

<#macro decorate model>
  <#if model.isComponent>
    <#if model.enum??>
      <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.valueOf(">
      <#assign javaConstructTypePostfix=")">
      <#assign javaGetValuePostfix=".toString()">
    <#else>
      <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      <#assign javaConstructTypePostfix=")">
      <#if model.isArraySchema>
        <#assign javaGetValuePostfix=".getElements()">
        <#assign addJsonNode="addCollectionOf${javaElementClassName}">
      <#else>
        <#if isExternal>
          <#assign javaGetValuePrefix="${javaGeneratedBuilderClassName}.to${javaElementClassName}(">
          <#assign javaGetValuePostfix=")">
        <#else>
          <#if model.isObjectSchema>
            <#assign javaGetValuePostfix=".getJsonObject()">
          <#else>
            <#assign javaGetValuePostfix=".getValue()">
          </#if>
        </#if>
      </#if>
    </#if>
  <#else>
    <#if model.isArraySchema>
      <@decorateArray model.baseSchema/>
      <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().with(">
      <#assign javaConstructTypePostfix=").build()">
    </#if>
  </#if>
  
  
  
  
  
  
<#------------------  
  <#if model.isArraySchema>
    //D9
    <@decorateArray model.baseSchema/>
    <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().with(">
    <#assign javaConstructTypePostfix=").build()">
  <#else>
    <#if model.isComponent>
      <#if model.reference.enum??>
        //D6
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.valueOf(">
        <#assign javaConstructTypePostfix=")">
      <#else>
        //D10
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
        <#assign javaConstructTypePostfix=")">
      </#if>
    </#if>
  </#if>
  
  
  
  
  
  
  
  
  
  <#if model.isComponent>
    //D4
    <#assign javaConstructTypePostfix=")">
    <#if javaGeneratedBuilderClassName?has_content>
    //D5
      <#if model.reference.enum??>
    //D6
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.valueOf(">
      <#else>
    //D7
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      </#if>
    <#else>
    //D8
      <#if model.isArraySchema>
    //D9
        <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().with(">
        <#assign javaConstructTypePostfix=").build()">
      <#else>
    //D10
        <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().build(">
      </#if>
    </#if>
  </#if>
  
  
  <#if model.isArraySchema>
    //D2 model.type=${model.type!"NULL"} model=${model}
    // D2 isComponent=${model.isComponent?c}
    <#if ! model.isComponent>
      <@decorateArray model/>
    </#if>
    <#assign javaGetValuePostfix=".getElements()">
  </#if>
  //D3
  
  <#if model.isObjectSchema>
    //D11
    <#if javaGeneratedBuilderClassName?has_content>
      <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
    <#else>
      <#assign javaConstructTypePrefix="new ${javaClassName}(">
    </#if>
    <#assign javaConstructTypePostfix=")">
    <#assign javaGetValuePostfix=".getJsonObject()">
    <#assign addJsonNode="add">
  </#if>
  ------------>
  
 <#------------ 
  <#switch model.elementType>
    <#case "Field">
      <@decorate model.type/>
      <#break>
      
    <#case "Array">
      <@decorateIfArray model.type/>
      <#break>
      
    <#case "Ref">
      <#assign javaConstructTypePostfix=")">
      <#if javaGeneratedBuilderClassName?has_content>
        <#if model.reference.enum??>
          <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.valueOf(">
        <#else>
          <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
        </#if>
      <#else>
        <#if model.reference.elementType=="Array">
          <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().with(">
          <#assign javaConstructTypePostfix=").build()">
        <#else>
          <#assign javaConstructTypePrefix="${javaClassName}.newBuilder().build(">
        </#if>
      </#if>
      <#switch model.reference.elementType>
        <#case "Array">
          <#assign javaGetValuePostfix=".getElements()">
          <#break>
        
        <#case "Object">
        <#case "AllOf">
        <#case "OneOf">
          <#assign javaGetValuePostfix=".getJsonObject()">
          <#assign addJsonNode="add">
          <#break>
        
        <#default>
          <#if isExternal>
            <#assign javaGetValuePrefix="${javaGeneratedBuilderClassName}.to${javaElementClassName}(">
            <#assign javaGetValuePostfix=")">
          <#else>
            <#assign javaGetValuePostfix=".getValue()">
          </#if>
      </#switch>
      <@decorateIfArray model.reference/>
      <#break>
      
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#if javaGeneratedBuilderClassName?has_content>
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      <#else>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      </#if>
      <#assign javaConstructTypePostfix=")">
      <#assign javaGetValuePostfix=".getJsonObject()">
      <#assign addJsonNode="add">
      <#break>
  </#switch>
  -------------->
</#macro>



<#macro setClassName2OBSOLETE model>
  //setClassName2 NOT SETTING isGenerated current value ${isGenerated?c}
  <#--assign isGenerated=true-->
  <#if model.attributes['javaExternalType']??>
    <#assign isExternal=true>
    <#assign javaClassName=model.attributes['javaExternalType']>
    <#assign javaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${javaClassName}">
    <#assign requiresChecks=false>
    <#if (model.attributes['isDirectExternal']!"false") != "true">
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}Builder">
      <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaFacadePackage}.${javaGeneratedBuilderClassName}">
    <#else>
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}">
    </#if>
  <#else>
    <#if model.enum??>
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}">
      <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaGenPackage}.${javaGeneratedBuilderClassName}">
      <#assign javaClassName=model.camelCapitalizedName>
    <#else>
      <#assign javaClassName=model.camelCapitalizedName>
      <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
    </#if>
  </#if>
</#macro>

<#macro setTypeDefClassName model>
  <#if model.attributes['javaExternalType']??>
    <#assign isExternal=true>
    <#assign javaClassName=model.attributes['javaExternalType']>
    <#assign javaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${javaClassName}">
    <#assign requiresChecks=false>
    <#if (model.attributes['isDirectExternal']!"false") != "true">
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}Builder">
      <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaFacadePackage}.${javaGeneratedBuilderClassName}">
    <#else>
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}">
    </#if>
  <#else>
    <#if model.enum??>
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}">
      <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaGenPackage}.${javaGeneratedBuilderClassName}">
      <#assign javaClassName=model.camelCapitalizedName>
    <#else>
      <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}.newBuilder()">
      <#assign javaClassName=model.camelCapitalizedName>
      <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
    </#if>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Set javaClassName for the given Schema
 #
 # Uses ${javaFieldClassName} and ${javaElementClassName} which must be set before calling this macro
 #
 # @param Schema model            A Schema for which the java class name is required.
 # @param String fieldClassName   Value of ${javaFieldClassName}
 #----------------------------------------------------------------------------------------------------->
<#macro setClassName model fieldClassName>
  <#if model.isComponent>
    <@setTypeDefClassName model.baseSchema/>
  <#else>
    <#assign javaClassName=fieldClassName>
  </#if>
  <#------switch model.elementType>
    <#case "Ref">
      <@setClassName model.reference model.reference.camelCapitalizedName/>
      <@setClassName2 model.reference/>
			<#break>
      
    
        <#assign javaClassName=fieldClassName>
      <#break>
      
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean"> 
    	  <#assign javaClassName=fieldClassName>
      <#break>
         
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
    <#case "Array">
    	  <@setClassName2 model/>
      <#break>
    
    <#case "TypeDef">
      // TypeDef
      <#assign isGenerated=true>
      <@setClassName2 model/>
      <#break>
      
    <#case "Field">
      <@setClassName model.type fieldClassName/>
      <#break>

  </#switch------------>
</#macro>


<#macro importModelSchemas model>
  <#list model.schemas as object>
    <#if object.parent.elementType != "AllOf">
import ${javaFacadePackage}.${object.camelCapitalizedName};
    </#if>
  </#list>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate imports for the nested types included in the given model element
 #
 # @param model     A model element
 #----------------------------------------------------------------------------------------------------->
<#macro importNestedTypes model>
  <#if model.elementType!="AllOf">
    <#list model.children as field>
      <#switch field.elementType>
        <#case "Object">
        <#case "AllOf">
        <#case "OneOf">
        <#case "TypeDef">
import ${javaFacadePackage}.${field.camelCapitalizedName};
          <@importNestedTypes field/>
          <#break>
      </#switch>
    </#list>
  </#if> 
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory declarations
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro declareFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.schemas as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf">
          <@declareFactories model child/>
          <#-- FALL THROUGH -->
        <#case "OneOf">
  private final ${(child.camelCapitalizedName + ".Factory")?right_pad(35)}  ${(child.camelName + "Factory_")?right_pad(35)} = new ${child.camelCapitalizedName}.Factory((${model.camelCapitalizedName}Factory)this);
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory registrations
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro registerFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.children as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf">
        <#case "OneOf">
    registry.register(${(child.camelCapitalizedName + ".TYPE_ID,")?right_pad(45)} ${child.camelName}Factory_);
          <#-- FALL THROUGH -->      
        <#default>
          <@registerFactories model child/>
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory getters
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro getFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.children as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf">
          <@getFactories model child/>
          <#-- FALL THROUGH -->
        <#case "OneOf">

    public ${child.camelCapitalizedName}.Factory get${child.camelCapitalizedName}Factory()
    {
      return ${child.camelName}Factory_;
    }
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>


<#macro importFieldTypes model includeImpls>
  <#if model.hasList || model.hasSet || model.elementType=="OneOf">
import java.util.Iterator;
  </#if>
  <#if model.hasList>
import java.util.List;
    <#if includeImpls>
import java.util.LinkedList;
import com.google.common.collect.ImmutableList;
    </#if>
  </#if>
  <#if model.hasSet>
import java.util.Set;
    <#if includeImpls>
import java.util.HashSet;
import com.google.common.collect.ImmutableSet;
    </#if>
  </#if>
  <#if model.hasByteString>
import com.google.protobuf.ByteString;
  </#if>
  
  <#list model.referencedTypes as field>
    <@setJavaType field/>
    <#list field.attributes as name, value>
    </#list>
    <#if javaFullyQualifiedClassName?has_content>
import ${javaFullyQualifiedClassName};
    </#if>
    <#if javaGeneratedBuilderFullyQualifiedClassName?has_content>
import ${javaGeneratedBuilderFullyQualifiedClassName};
    </#if>
    <@importNestedTypes field/>
  </#list>
  <@importNestedTypes model/>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Limit checking.
 #
 # I think we can just look for all checks in all cases rather than doing array limits and value limits
 # separately.
 #----------------------------------------------------------------------------------------------------->

<#function checkLimitsClass model>
  <#if model.isComponent>
    <#return true>
  </#if>
  <#list model.fields as field>
    <#if isCheckLimits(field)>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#macro checkLimitsClassThrows model><#list model.fields as field><#if isCheckLimits(field)> throws BadFormatException<#return></#if></#list></#macro>

<#macro checkLimitsThrows model><#if isCheckLimits(model)> throws BadFormatException</#if></#macro>

<#function isCheckLimits model>
  <#switch model.elementType>
    <#case "Field">
      <#if model.type.minimum?? ||  model.type.maximum?? || model.required>
        <#return true>
      </#if>
      <#break>
      
    <#case "Ref">
      <#return isCheckLimits(model.reference)/>
      <#break>
      
    <#case "Array">
      <#if model.minItems?? ||  model.maxItems??>
        <#return true>
      </#if>
      
    <#default>
      <#if model.minimum?? ||  model.maximum??>
        <#return true>
      </#if>
  </#switch>
  <#return false>
</#function>

<#------------------------------------------------------------------------------------------------------
 # Generate min/max checks for the given type if necessary
 #
 # This is a macro sub-routine, from templates you probably should be calling checkLimits.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param name      The name of the value being checked which is output in the message of thrown exceptions
 #----------------------------------------------------------------------------------------------------->
<#macro checkLimits2 indent model name>
  <#if model.minimum??>
${indent}if(${name} != null && ${name} < ${model.minimumAsString})
${indent}  throw new BadFormatException("Value " + ${name} + " of ${name} is less than the minimum allowed of ${model.minimum}");

  </#if>
  <#if model.maximum??>
${indent}if(${name} != null && ${name} > ${model.maximumAsString})
${indent}  throw new BadFormatException("Value " + ${name} + " of ${name} is more than the maximum allowed of ${model.maximum}");

  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate limit checks for the given type if necessary
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param name      The name of the value being checked which is output in the message of thrown exceptions
 #----------------------------------------------------------------------------------------------------->
<#macro checkLimits indent model name>
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
      <@checkLimits2 indent model name/>
      <#break>
      
    <#case "Field">
      <#if model.required>     
${indent}if(${name} == null)
${indent}  throw new BadFormatException("${name} is required.");

      </#if>
      <@checkLimits2 indent model.type name/>
      <#break>
  </#switch>
</#macro>


<#------------------------------------------------------------------------------------------------------
 # Generate limit checks for the given Array type if necessary
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param var       The name of a variable to which the extracted value will be assigned 
 # @param name      The name of an array value being checked
 #----------------------------------------------------------------------------------------------------->
<#macro checkItemLimits indent model name var>
  <#switch model.elementType>
    <#case "Array">
      <#if model.minItems??>

${indent}if(${var}.size() < ${model.minItems})
${indent}{
${indent}  throw new BadFormatException("${name} has " + ${var}.size() + " items but at least ${model.minItems} are required");
${indent}}
      </#if>
      <#if model.maxItems??>
${indent}if(${var}.size() > ${model.maxItems})
${indent}{
${indent}  throw new BadFormatException("${name} has " + ${var}.size() + " items but at most ${model.maxItems} are allowed");
${indent}}
      </#if>
      <#break>
  </#switch>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Create a field from a Json DOM node.
 # The java variable "node" must have already been set to an IJsonDomNode and must not be null.
 #
 # NB this macro calls <@setJavaType field/>
 # @param indent    An indent string which is output at the start of each line generated
 # @param field     A model element representing the field to generate for
 # @param var       The name of a variable to which the extracted value will be assigned 
 #----------------------------------------------------------------------------------------------------->
<#macro generateCreateFieldFromJsonDomNode indent field var>
  <@setJavaType field/>
  <#if field.isComponent>
    <#if field.isObjectSchema>
${indent}if(node instanceof ImmutableJsonObject)
${indent}{
${indent}  ${var} = _factory.getModel().get${javaClassName}Factory().newInstance((ImmutableJsonObject)node);
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an Object node not " + node.getClass().getName());
${indent}}
    <#else>
      <#if field.isArraySchema>
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
${indent}  ${var} = ${javaClassName}.newBuilder().with((ImmutableJsonArray)node).build();
<@checkItemLimits indent field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an Array node not " + node.getClass().getName());
${indent}}
      <#else>
${indent}if(node instanceof I${javaElementClassName}Provider)
${indent}{
${indent}  ${javaElementClassName} value = ((I${javaElementClassName}Provider)node).as${javaElementClassName}();

${indent}  try
${indent}  {
${indent}    ${var} = ${javaConstructTypePrefix}value${javaConstructTypePostfix};
${indent}  }
${indent}  catch(RuntimeException e)
${indent}  {
${indent}    throw new BadFormatException("Value \"" + value + "\" for ${field.camelName} is not a valid value", e);
${indent}  }
${indent}}
${indent}else
${indent}{
${indent}    throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
${indent}}     
        </#if>
      </#if>
  <#else>
    <#if field.isArraySchema>
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
${indent}  ${var} = ((ImmutableJsonArray)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
<@checkItemLimits indent field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
${indent}}
    <#else> 
${indent}if(node instanceof I${javaElementClassName}Provider)
${indent}{
${indent}  ${javaFieldClassName} ${field.camelName} = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
      <#if requiresChecks>
        <@checkLimits "${indent}  " field field.camelName/>
      </#if>
${indent}  ${var} = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
${indent}}
${indent}else
${indent}{
${indent}    throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
${indent}}
    </#if>
  </#if>
</#macro>

<#macro OBSOLETEenerateCreateFieldFromJsonDomNode indent field var>
  <@setJavaType field/>
  <#if field.elementType=="Field">
    <#if field.type.elementType=="Ref">
      <#assign elementType=field.type.reference.elementType>
    <#else>
      <#assign elementType=field.type.elementType>
    </#if>
  <#else>
    <#if field.elementType=="Ref">
      <#assign elementType=field.reference.elementType>
    <#else>
      <#assign elementType=field.elementType>
    </#if>
  </#if>
  <#if isGenerated>
    <#switch elementType>
      <#case "Object">
      <#case "AllOf">
      <#case "OneOf">
${indent}if(node instanceof ImmutableJsonObject)
${indent}{
${indent}  ${var} = _factory.getModel().get${javaClassName}Factory().newInstance((ImmutableJsonObject)node);
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an Object node not " + node.getClass().getName());
${indent}}
        <#break>
      
      <#case "Array">
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
${indent}  ${var} = ${javaConstructTypePrefix}(ImmutableJsonArray)node${javaConstructTypePostfix};
<@checkItemLimits indent field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an Array node not " + node.getClass().getName());
${indent}}
        <#break>
      
      <#default>
${indent}if(node instanceof I${javaElementClassName}Provider)
${indent}{
${indent}  ${javaElementClassName} value = ((I${javaElementClassName}Provider)node).as${javaElementClassName}();

${indent}  try
${indent}  {
${indent}    ${var} = ${javaConstructTypePrefix}value${javaConstructTypePostfix};
${indent}  }
${indent}  catch(RuntimeException e)
${indent}  {
${indent}    throw new BadFormatException("Value \"" + value + "\" for ${field.camelName} is not a valid value", e);
${indent}  }
${indent}}
${indent}else
${indent}{
${indent}    throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
${indent}}     
        <#break>
    </#switch>
  <#else>
    <#if field.isArraySchema>
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
      <#if field.isObjectSchema>
${indent}  ${var} = _factory_.getModel().get${javaElementClassName}Factory().newInstance${javaCardinality}((ImmutableJsonArray)node);
      <#else>
${indent}  ${var} = ((ImmutableJsonArray)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
      </#if>
<@checkItemLimits indent field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
${indent}}
    <#else>  
${indent}if(node instanceof I${javaElementClassName}Provider)
${indent}{
${indent}  ${javaFieldClassName} ${field.camelName} = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
      <#if requiresChecks>
        <@checkLimits "${indent}  " field field.camelName/>
      </#if>
${indent}  ${var} = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
${indent}}
${indent}else
${indent}{
${indent}    throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
${indent}}
    </#if>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Set various variables for generation of the given operation.
 #
 # Also outputs a javadoc comment.
 #
 # NB this macro calls <@setJavaType operation.response.schema/>
 # @param operation   An operation object 
 #----------------------------------------------------------------------------------------------------->
<#macro setJavaMethod operation>
  <#if operation.response??>
    <@setJavaType operation.response.schema/>
    <#assign methodResponseType="${javaClassName}">
    <#if operation.response.isRequired>
      <#assign methodResponseDecl="@Nonnull ${javaClassName}">
      <#assign methodThrows="throws PermissionDeniedException, ServerErrorException">
    <#else>
      <#assign methodResponseDecl="@Nullable ${javaClassName}">
      <#assign methodThrows="throws PermissionDeniedException, NoSuchRecordException, ServerErrorException">
    </#if>
    <#if operation.payload??>
      <#assign methodStyle="PayloadResponse">
    <#else>
      <#assign methodStyle="Response">
    </#if>
  <#else>
    <#assign methodResponseType="">
    <#assign methodResponseDecl="void">
    <#assign methodThrows="throws PermissionDeniedException, ServerErrorException">
    <#if operation.payload??>
      <#assign methodStyle="Payload">
    <#else>
      <#assign methodStyle="">
    </#if>
  </#if>
  <#if operation.payload??>
    <@setJavaType operation.payload.schema/>
    <#assign methodPayloadType="${javaClassName}">
    <#if operation.payload.isRequired>
      <#assign methodPayloadDecl="@Nonnull ${javaClassName}">
    <#else>
      <#assign methodPayloadDecl="@Nullable ${javaClassName}">
    </#if>
  <#else>
    <#assign methodPayloadType="">
    <#assign methodPayloadDecl="">
  </#if>
  <@setDescription operation/>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Print javadoc comment for the given operation.
 #
 # NB this macro calls setJavaMethod and setJavaType
 # @param operation   An operation object 
 #----------------------------------------------------------------------------------------------------->
<#macro printMethodJavadoc operation>
<@setJavaMethod operation/>
  /**
   * ${operation.name} ${operation.pathItem.path}
   * ${summary}
   * ${description}
  <#list operation.parameters as parameter>
    <@setJavaType parameter.schema/>
   * ${parameter.camelName?right_pad(25)} ${summary}
  </#list>
  <#if operation.response??>
    <@setJavaType operation.response.schema/>
    <#assign methodReturnPlaceholder="return null;">
    <#if operation.response.schema.description??>
   * @return ${operation.response.schema.description}
    <#else>
   * @return A ${javaClassName}
    </#if>
    <#if operation.response.isRequired>
    <#else>
   * or <code>null</code>
   * @throws NoSuchRecordException            If there is no data to return
    </#if>
  </#if>
   * @throws PermissionDeniedException        If the caller lacks necessary entitlements for the action
   * @throws ServerErrorException             If an unexpected error occurred
   */
</#macro>