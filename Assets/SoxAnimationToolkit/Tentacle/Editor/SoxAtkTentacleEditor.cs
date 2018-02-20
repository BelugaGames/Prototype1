using UnityEngine;
//using System.Collections;
using UnityEditor;

[CustomEditor(typeof(SoxAtkTentacle))]
public class SoxAtkTentacleEditor : Editor
{
    public override void OnInspectorGUI()
    {
        SoxAtkTentacle tentacle = (SoxAtkTentacle)target;

        // GUI레이아웃 시작=======================================================
        Undo.RecordObject(target, "Tentacle Changed Settings");

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Auto register nodes"))
        {
            AutoRegisterNodes(tentacle);
        }

        if (GUILayout.Button("Clear nodes"))
        {
            ClearNodes(tentacle);
        }
        GUILayout.EndHorizontal();

        Undo.FlushUndoRecordObjects();
        
        DrawDefaultInspector();

        // GUI레이아웃 끝========================================================
    } // end of OnInspectorGUI()

    private void AutoRegisterNodes(SoxAtkTentacle tentacle)
    {
        for (int i = 1; i < tentacle.m_nodes.Length; i++)
        {
            if (tentacle.m_nodes[i] == null && tentacle.m_nodes[i - 1] != null)
            {
                if (tentacle.m_nodes[i - 1].childCount > 0)
                {
                    tentacle.m_nodes[i] = tentacle.m_nodes[i - 1].GetChild(0);
                }
            }
        }
    }

    private void ClearNodes(SoxAtkTentacle tentacle)
    {
        for (int i = 0; i < tentacle.m_nodes.Length; i++)
        {
            tentacle.m_nodes[i] = null;
        }
    }
}
