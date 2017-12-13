<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>

import com.symphony.s2.japigen.runtime.IModelObject;

<@importFieldTypes model true/>

<#include "../Object/Object.ftl">
public interface I${model.camelCapitalizedName}ModelObject extends IModelObject
{
  Object getPayload();
  String getDiscriminator();
}
<#include "../S2-japigen-template-java-Epilogue.ftl">