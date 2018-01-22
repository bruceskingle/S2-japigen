<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import com.symphony.s2.japigen.runtime.IModelHandler;

public interface I${modelJavaClassName}ModelHandler extends IModelHandler
{
}
<#include "../S2-japigen-template-java-Epilogue.ftl">