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
 #                                 code, e.g. for imports
 #
 # javaFieldClassName              Name of Java class for the field inside a generated class
 #  
 # javaElementClassName            Name of Java class for the the elements of a collection. For
 #                                 non-collection types this is the same as javaFieldClassName
 #  
 # isNotNullable                   Boolean is true for required fields in an object, otherwise false
 #  
 # isArrayType                     Boolean is true for array fields, otherwise false
 #  
 # isGenerated                     Boolean is true for fields which require range checks otherwise false
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
 *    name                          ${javaField.name}
 *    camelName                     ${javaField.camelName}
 *    camelCapitalizedName          ${javaField.camelCapitalizedName}
 *    snakeName                     ${javaField.snakeName}
 *    snakeCapitalizedName          ${javaField.snakeCapitalizedName}
 *    elementType                   ${javaField.elementType}
 *    canFailValidation             ${javaField.canFailValidation?c}
 *
 *    javaClassName                 ${javaClassName!"NULL"}
 *    javaFullyQualifiedClassName   ${javaFullyQualifiedClassName!"NULL"}
 *    javaFieldClassName            ${javaFieldClassName!"NULL"}
 *    javaElementClassName          ${javaElementClassName!"NULL"}
 *    isNotNullable                 ${isNotNullable?c}
 *    isArrayType                   ${isArrayType?c}
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
  <#assign isNotNullable=false>
  <#assign isArrayType=false>
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
    
    <#case "Array">
      <#switch model.cardinality>
        <#case "SET">
          <#return "Set<${getJavaClassName(model.elementSchema)}>">
          
        <#default>
          <#return "List<${getJavaClassName(model.elementSchema)}>">
      </#switch>
    
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

<#macro decorate model>
  <#switch model.elementType>
    <#case "Field">
      <#if model.required>
        <#assign isNotNullable=true>
      </#if>
      <@decorate model.type/>
      <#break>
      
    <#case "Array">
      <@decorateIfArray model/>
      <#break>
      
    <#case "Ref">
      <#if javaGeneratedBuilderClassName?has_content>
        <#if model.reference.enum??>
          <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.valueOf(">
        <#else>
          <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
        </#if>
      <#else>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      </#if>
      <#assign javaConstructTypePostfix=")">
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
</#macro>

<#macro decorateIfArray model>
  <#if model.elementType=="Array">
    <#assign isArrayType=true>
    // TRACE javaElementClassName = ${javaElementClassName}
    // model.items.elementType = ${model.items.elementType!NULL}
    <#if model.items.elementType == "Ref">
      <#assign addJsonNode="addCollectionOfDomNode">
    <#else>
      <#assign addJsonNode="addCollectionOf${javaElementClassName}">
    </#if>
    <#if ! isGenerated>
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaTypeCopyPrefix="ImmutableSet.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new HashSet<>()">
          <#break>
          
        <#default>
          <#assign javaTypeCopyPrefix="ImmutableList.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new LinkedList<>()">
      </#switch>
    </#if>
    <#switch model.cardinality>
      <#case "SET">
        <#assign javaCardinality="Set">
        <#break>
        
      <#default>
        <#assign javaCardinality="List">
    </#switch>
  </#if>
</#macro>

<#macro setClassName2 model>
  <#assign isGenerated=true>
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

<#macro setClassName model fieldClassName>
  <#switch model.elementType>
    <#case "Ref">
      <@setClassName model.reference model.reference.camelCapitalizedName/>
      <@setClassName2 model.reference/>
			<#break>
      
    <#case "Array">
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean"> 
    	  <#assign javaClassName=fieldClassName>
      <#break>
         
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
    	  <@setClassName2 model/>
      <#break>
    
    <#case "Field">
      <@setClassName model.type fieldClassName/>
      <#break>

  </#switch>
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
 # Generate enums if necessary
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 #----------------------------------------------------------------------------------------------------->
<#macro generateEnums indent model>
  <#assign hasEnums=false>
  <@generateEnumVars indent model/>
  <#if hasEnums>
    <@generateEnumValues indent model/>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate enums variables
 #
 # This is a macro sub-routine, from templates you probably should be calling generateEnums.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 #----------------------------------------------------------------------------------------------------->
<#macro generateEnumVars indent model>
  <#list model.fields as field>
    <#switch field.elementType>
      <#case "Field">
        <@generateOneEnumVar indent field.type/>
        <#break>
      
      <#case "Object">
        <@generateEnumVars indent field/>
        <#break>
    </#switch>
  </#list>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate a single enum variable
 #
 # This is a macro sub-routine, from templates you probably should be calling generateEnums.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 #----------------------------------------------------------------------------------------------------->
<#macro generateOneEnumVar indent field>
  <#if field.enum??>
    <#assign hasEnums=true>
${indent}private static final Set<String> _enumOf${field.camelName} = new HashSet<>();
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate enums values
 #
 # This is a macro sub-routine, from templates you probably should be calling generateEnums.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 #----------------------------------------------------------------------------------------------------->
<#macro generateEnumValues indent model>

${indent}static
${indent}{
  <#list model.fields as field>
    <#switch field.elementType>
      <#case "Field">
        <@generateOneEnumValue indent field.type/>
        <#break>
      
      <#case "Object">
        <@generateEnumValues indent field/>
        <#break>
    </#switch>
  </#list>
${indent}}

</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate values for a single enums variable
 #
 # This is a macro sub-routine, from templates you probably should be calling generateEnums.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 #----------------------------------------------------------------------------------------------------->
<#macro generateOneEnumValue indent field>
    <#if field.enum??>

      <#list field.enum.values as value>
${indent}  _enumOf${field.camelName}.add("${value}");
      </#list>
    </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Limit checking.
 #
 # I think we can just look for all checks in all cases rather than doing array limits and value limits
 # separately.
 #----------------------------------------------------------------------------------------------------->

<#function checkLimitsClass model>
  <#if model.isTypeDef>
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
  <#if model.enum??>
${indent}if(!_enumOf${name}.contains(${name}))
${indent}  throw new BadFormatException("Value " + ${name} + " of ${name} is not one of the permitted enum constants.");

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
 # @param indent    TO BE ADDED: An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param var       The name of a variable to which the extracted value will be assigned 
 # @param name      The name of an array value being checked
 #----------------------------------------------------------------------------------------------------->
<#macro checkItemLimits model name var>
  <#switch model.elementType>
    <#case "Array">
      <#if model.minItems??>

    if(${var}.size() < ${model.minItems})
    {
      throw new BadFormatException("${name} has " + ${var}.size() + " items but at least ${model.minItems} are required");
    }
      </#if>
      <#if model.maxItems??>
    if(${var}.size() > ${model.maxItems})
    {
      throw new BadFormatException("${name} has " + ${var}.size() + " items but at most ${model.maxItems} are allowed");
    }
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
      
      <#default>
        <#if isArrayType>
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
${indent}  ${var} = ${javaConstructTypePrefix}(ImmutableJsonArray)node, ((ImmutableJsonArray)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class)${javaConstructTypePostfix};
${indent}  <@checkItemLimits field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
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
        <#break>
    </#switch>
  <#else>
    <#if isArrayType>
${indent}if(node instanceof ImmutableJsonArray)
${indent}{
      <#if field.isObjectSchema>
${indent}  ${var} = _factory_.getModel().get${javaElementClassName}Factory().newInstance${javaCardinality}((ImmutableJsonArray)node);
      <#else>
${indent}  ${var} = ((ImmutableJsonArray)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
      </#if>
${indent}  <@checkItemLimits field field.camelName var/>
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
<@setDescription operation/>
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
      <#assign methodReturnType="@Nonnull ${javaClassName}">
      <#assign methodThrows="throws PermissionDeniedException, ServerErrorException">
    <#else>
   * or <code>null</code>
      <#assign methodReturnType="@Nullable ${javaClassName}">
      <#assign methodThrows="throws PermissionDeniedException, NoSuchRecordException, ServerErrorException">
   * @throws NoSuchRecordException            If there is no data to return
    </#if>
  <#else>
    <#assign methodReturnType="void">
    <#assign methodReturnPlaceholder="">
    <#assign methodThrows="throws PermissionDeniedException, ServerErrorException">
  </#if>
   * @throws PermissionDeniedException        If the caller lacks necessary entitlements for the action
   * @throws ServerErrorException             If an unexpected error occurred
   */
</#macro>