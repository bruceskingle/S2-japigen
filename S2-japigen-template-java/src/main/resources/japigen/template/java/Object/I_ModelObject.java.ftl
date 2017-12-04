<#include "../S2-japigen-template-java-Prologue.ftl">

import com.symphony.s2.japigen.runtime.IAbstractModelObject;

<@importFieldTypes model true/>
import ${javaFacadePackage}.${model.camelCapitalizedName};
import ${javaFacadePackage}.${model.camelCapitalizedName}.Builder;

<#include "Object.ftl">
public interface I${model.camelCapitalizedName}ModelObject extends IAbstractModelObject
{
<#list model.children as field>
  <@setJavaType field/>
  
  ${javaType} get${field.camelCapitalizedName}();
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">