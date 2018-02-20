//using System.Collections;
//using System.Collections.Generic;
using System;
using System.Reflection;
using UnityEngine;

public class SoxAtkTentacle : MonoBehaviour {
    [HideInInspector]
    public float m_version = 1.0f;

    private bool m_initialized = false;

    public bool m_keepInitialRotation = true;

    // 지글본과 연동을 위해서 에디터에서 보이는 m_nodes가 있고 실제 회전에 사용되는 m_nodes이 있다.
    // m_nodes를 검사해서 지글본이 없으면 m_nodes에 원래 노드를 넣고, 지글본이 있으면 지글본의 헬퍼 본을 m_nodes에 넣는다.
    // 지글본에 텐타클이 적영되면 지글본의 숨겨진 기준 본을 텐터클이 흔들게 된다.
    public Transform[] m_nodes = new Transform[5];

    private Quaternion[] m_nodesSaveLocalRotations = new Quaternion[5];
    private float[] m_nodesSaveDistances = new float[5];
    private float m_distanceAll = 0.0f;
    private float[] m_nodesSaveStrengths = new float[5];
    private Vector3[] m_wavesetMixEuler = new Vector3[5];

    private Transform m_rootNode;

    public enum Axis { X, Y, Z }

    private const float mc_freqMul = 0.01f;

    [System.Serializable]
    public struct Waveset
    {
        public Axis m_rotateAxis;
        public float m_frequency;
        [HideInInspector]
        public float m_frequencyProxy;
        public float m_strengthStart;
        public float m_strengthEnd;
        public float m_speed;
        public float m_offset;

        public Waveset(Axis rotateAxis, float frequency, float strengthStart, float strengthEnd, float speed, float offset)
        {
            m_rotateAxis = rotateAxis;
            m_frequency = frequency;
            m_frequencyProxy = frequency * mc_freqMul;
            m_strengthStart = strengthStart;
            m_strengthEnd = strengthEnd;
            m_speed = speed;
            m_offset = offset;
        }
    }

    public Waveset[] wavesets = new Waveset[1]
    {
        new Waveset(Axis.X, -20.0f, 5.0f, 40.0f, 5.0f, 0.0f)
    };

    // Tentacle에서 지글본의 헬퍼 노드들을 인식하려면 지글본의 초기화는 Awake에서 하고 텐타클의 초기화는 Start에서 한다.
    void Start () {
        if (!m_initialized && this.enabled)
            Initialize();
    }

    private void OnEnable()
    {
        if (!m_initialized)
            Initialize();
    }

    private void Initialize()
    {
        if (m_nodes[0] != null)
        {
            m_rootNode = m_nodes[0].parent;
        }

        SaveLocalRotations();
        SaveDistances();
        SaveStrengths();

        SaveNodesReal();

        // m_wavesetMixEuler 초기화
        for (int p = 0; p < m_wavesetMixEuler.Length; p++)
        {
            m_wavesetMixEuler[p] = Vector3.zero;
        }

        m_initialized = true;
    }
	
	// Update is called once per frame
	void Update () {
        if (wavesets == null)
            return;

        // 루트노드 로테이션 준비
        Quaternion rootRotation = Quaternion.identity;
        if (m_rootNode != null)
        {
            rootRotation = m_rootNode.rotation;
        }

        // wavesets 들을 합산한 m_wavesetMixEuler를 계산한다.
        for (int i = 0; i < wavesets.Length; i++)
        {
            for (int p = 0; p < m_nodes.Length; p++)
            {
                float tempAngle = Mathf.Sin(
                    (m_nodesSaveDistances[p] + wavesets[i].m_offset)
                    * wavesets[i].m_frequencyProxy
                    + (Time.time * wavesets[i].m_speed)
                    ) * m_nodesSaveStrengths[p];

                switch (wavesets[i].m_rotateAxis)
                {
                    case Axis.X:
                        m_wavesetMixEuler[p].x += tempAngle;
                        break;
                    case Axis.Y:
                        m_wavesetMixEuler[p].y += tempAngle;
                        break;
                    case Axis.Z:
                        m_wavesetMixEuler[p].z += tempAngle;
                        break;
                }
            }
        }

        // m_keepInitialRotation 옵션에 따른 각 노드의 로테이션 반영
        for (int p = 0; p < m_nodes.Length; p++)
        {
            if (m_nodes[p] != null)
            {
                if (m_keepInitialRotation)
                {
                    m_nodes[p].rotation = rootRotation * m_nodesSaveLocalRotations[p] * Quaternion.Euler(m_wavesetMixEuler[p]);
                }
                else
                {
                    m_nodes[p].rotation = rootRotation * Quaternion.Euler(m_wavesetMixEuler[p]);
                }
            }

            // 다음 업데이트를 위해 미리 초기화해둔다.
            m_wavesetMixEuler[p] = Vector3.zero;
        }
    }

    private void OnValidate()
    {
        // m_nodes 의 숫자를 변경할 때 Euler 저장 배열과 Distance 저장 배열의 숫자도 같이 변경한다.
        if (wavesets != null)
        {
            for (int i = 0; i < wavesets.Length; i++)
            {
                // 노드는 최소 1개 이상이 되도록 강제한다.
                if (m_nodes.Length < 1)
                {
                    m_nodes = new Transform[1];
                }

                // m_nodesSaveLocalRotations 하나만 숫자가 달라도 나머지 다른 배열들 모두 숫자를 재설정하려고 했으나 중간에 변수가 추가되는 등 예외상황에서 배열 수가 안맞는 일이 있어서 매 번 죄다 체크
                if (m_nodes.Length != m_nodesSaveLocalRotations.Length)
                {
                    m_nodesSaveLocalRotations = new Quaternion[m_nodes.Length];
                }

                if (m_nodes.Length != m_nodesSaveDistances.Length)
                {
                    m_nodesSaveDistances = new float[m_nodes.Length];
                }

                if (m_nodes.Length != m_nodesSaveStrengths.Length)
                {
                    m_nodesSaveStrengths = new float[m_nodes.Length];
                }

                if (m_nodes.Length != m_wavesetMixEuler.Length)
                {
                    m_wavesetMixEuler = new Vector3[m_nodes.Length];
                }

                wavesets[i].m_frequencyProxy = wavesets[i].m_frequency * mc_freqMul;
            }
        }

        SaveStrengths();
    }

    // 지정된 노드들의 로컬 회전을 Start에서 기억시킨다.
    public void SaveLocalRotations()
    {
        if (wavesets == null)
            return;

        Quaternion rootRotation = Quaternion.identity;
        if (m_rootNode != null)
        {
            rootRotation = m_rootNode.rotation;
        }

        for (int p = 0; p < m_nodes.Length; p++)
        {
            if (m_nodes[p] != null)
            {
                m_nodesSaveLocalRotations[p] = Quaternion.Inverse(rootRotation) * m_nodes[p].rotation;
            }
            else
            {
                m_nodesSaveLocalRotations[p] = Quaternion.identity;
            }
        }
    }

    // 지정된 노드들의 Distance 를 Start에서 기억시킨다. 자신의 바로 앞 노드로부터의 거리이고 가장 앞 노드는 0
    public void SaveDistances()
    {
        if (wavesets == null)
            return;

        m_distanceAll = 0.0f;
        m_nodesSaveDistances[0] = 0.0f;
        for (int p = 1; p < m_nodes.Length; p++)
        {
            if (m_nodes[p] != null && m_nodes[p - 1] != null)
            {
                float avrScale = (Mathf.Abs(m_nodes[p].lossyScale.x) + Mathf.Abs(m_nodes[p].lossyScale.y) + Mathf.Abs(m_nodes[p].lossyScale.z)) / 3.0f;
                m_nodesSaveDistances[p] = m_distanceAll + Vector3.Distance(m_nodes[p].position, m_nodes[p-1].position) / avrScale;
            }
            else
            {
                m_nodesSaveDistances[p] = 0.0f;
            }
            m_distanceAll = m_nodesSaveDistances[p];
        }
    }

    // SaveStrengths는 외부에서 세팅할 일이 없어서 private
    // strength 시작과 끝 값을 매 Update마다 lerp 연산하지 않기 위해서 노드마다 각자의 strength를 미리 계산해둔다.
    // SaveDistances가 먼저 연산된 이후에 이것을 해야한다. distance 기반이기때문.
    private void SaveStrengths()
    {
        if (wavesets == null)
            return;

        for (int i = 0; i < wavesets.Length; i++)
        {
            float strengthGap = wavesets[i].m_strengthEnd - wavesets[i].m_strengthStart;
            m_nodesSaveStrengths[0] = wavesets[i].m_strengthStart; // 최초 노드는 Strength 시작값과 일치
            for (int p = 1; p < m_nodes.Length; p++)
            {
                float bias = m_nodesSaveDistances[p] / m_distanceAll;
                m_nodesSaveStrengths[p] = wavesets[i].m_strengthStart + (strengthGap * bias);
            }
        }
    }

    private void SaveNodesReal()
    {
        /*
        for (int i = 0; i < m_nodes.Length; i++)
        {
            SoxAtkJiggleBone jiggleBone = m_nodes[i].GetComponent<SoxAtkJiggleBone>();
            if (jiggleBone != null)
            {
                m_nodes[i] = jiggleBone.GetTargetRoot();
            }
        }
        */
        // 원래는 이랬던 코드가...

        // SoxAtkJiggleBone클래스가 설치되지 않은 곳에서도 SoxAtkJiggleBone의 함수를 실행하고 값을 얻어오기 위해 리플랙션의 복잡한 과정을 거친다.
        Type jiggleBonetype = Type.GetType("SoxAtkJiggleBone");
        if (jiggleBonetype == null)
            return;

        MethodInfo getTargetRoot = jiggleBonetype.GetMethod("GetTargetRoot");
        MethodInfo getThisEnabled = jiggleBonetype.GetMethod("GetThisEnabled");

        for (int i = 0; i < m_nodes.Length; i++)
        {
            if (m_nodes[i] != null)
            {
                object jiggleBone = m_nodes[i].GetComponent(jiggleBonetype);
                if (jiggleBone != null)
                {
                    if ((bool)getThisEnabled.Invoke(jiggleBone, null))
                    {
                        m_nodes[i] = (Transform)getTargetRoot.Invoke(jiggleBone, null);
                    }
                }
            }
        }
    }
}
