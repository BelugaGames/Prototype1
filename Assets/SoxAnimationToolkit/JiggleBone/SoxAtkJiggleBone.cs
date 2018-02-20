//using System.Collections;
//using System.Collections.Generic;
using System;
using UnityEngine;

public class SoxAtkJiggleBone : MonoBehaviour {
    [HideInInspector]
    public float m_version = 1.0f;

    private bool m_initialized = false;
    [HideInInspector]
    public bool m_head = true;
    private bool m_treeInit = false;
    [HideInInspector]
    public SoxAtkJiggleBone[] m_tree;

    private Transform meTrans;

    public enum Axis { X, Y, Z }
    public enum SimType { Simple, KeepDistance }

    public SimType m_simType = SimType.Simple;

    public float m_targetDistance = 3.0f;
    public bool m_targetFlip = false;

    private const float mc_tensionMul = 0.1f;
    private float m_tensionProxy;
    public float m_tension = 30.0f;
    [Range(0.0f, 1.0f)]
    public float m_inercia = 0.85f;

    // 최적화를 위해 옵션이 바뀔 때에만 미리 세팅해두는 값, 업벡터는 월드가 아닌 오브젝트를 참조할 경우 매 프레임 세팅되기도 한다.
    private Vector3 m_upVector;

    public Axis m_lookAxis = Axis.Z;
    public bool m_lookAxisFlip = false;

    public Axis m_sourceUpAxis = Axis.Y;
    public bool m_sourceUpAxisFlip = false;
    // m_lookAxis와 m_sourceUpAxis가 같아지면 바로 전 m_sourceUpAxis로 되돌리기 위해 바로 이전 m_sourceUpAxis를 기억하는 변수
    private Axis m_sourceUpAxisBefore;

    public bool m_upWorld = false;
    public Transform m_upNode;
    public Axis m_upNodeAxis = Axis.Y;
    private bool m_upNodeAutoSet = false; // 최초 지글본 적용시 부모를 업노드로 자동 지정했는지 체크(1회만 해야함)

    public enum UpnodeControl { LookAt, AxisAlignment }
    public UpnodeControl m_upnodeControl = UpnodeControl.AxisAlignment;

    private Transform m_target;
    private Transform m_targetRoot;
    private Transform m_proxyLook;
    private Transform m_proxyAlign;

    private Vector3 m_boneEndDragWPos;
    private Vector3 m_forceVec;
    private Vector3 m_resultVec;
    private Vector3 m_lookWPos;

    private Vector3 m_beforTargetWPos;
    private Vector3 m_beforeInerciaVec;

    public bool m_optShowGizmosAtPlaying = false;
    public bool m_optShowGizmosAtEditor = true;
    public float m_optGizmoSize = 0.1f;
    public bool m_optShowHiddenNodes = false;

    // 히든 노드를 보이고 안보이고 하는 변화가 지글본에서 발생하는데
    // 하이러키 다시그리는건 에디터에서 호출해야하기때문에
    // 지글본에서의 변화가 발생했는지 여부를 기록하는 플래그
    // 에디터에서 토글 변화 발생하자마자 다시그리기 해봐야 지글본에서 하이러키 처리하기 전이다.
    // 지글본에서 하이러키 처리 직후 이 플래그를 세팅해주고 에디터에서 플래그 검사하여 강제 다시그리기
    public bool m_hierarchyChanged = false;

    // Tentacle에서 지글본의 헬퍼 노드들을 인식하려면 지글본의 초기화는 Awake에서 하고 텐타클의 초기화는 Start에서 한다.
    void Awake () {
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
        meTrans = transform;

        // tree가 초기화 안되어있으면
        if (!m_treeInit)
        {
            m_tree = new SoxAtkJiggleBone[] { this };

            // tree 초기화 했음 표시
            m_treeInit = true;
        }

        // 누가 우두머리인지 결정한다. m_head, m_tree 결정
        SetHead();

        m_upVector = Vector3.up;

        // m_targetRoot는 지글본과 형제 계층구조에서 지글본을 따라다니면서 타겟 위치의 부모 역할을 한다. 지글본과 스케일도 동기화 해야함.
        m_targetRoot = new GameObject("SoxAtkJiggleboneTargetRoot_" + transform.name).transform;
        m_targetRoot.parent = meTrans.parent;
        m_targetRoot.hideFlags = HideFlags.HideInHierarchy;
        m_targetRoot.localPosition = meTrans.localPosition;
        m_targetRoot.localRotation = meTrans.localRotation;
        m_targetRoot.localScale = meTrans.localScale;

        // m_target은 지글본의 최후 도착지점 역할
        m_target = new GameObject("SoxAtkJiggleboneTarget_" + transform.name).transform;
        m_target.parent = m_targetRoot;
        m_target.hideFlags = HideFlags.HideInHierarchy;
        SetTargetDistance(); // m_lookAxis의 옵션에 따라서 m_target의 위치를 변경한다. 
        m_target.localRotation = Quaternion.identity;
        m_target.localScale = Vector3.one;
        m_boneEndDragWPos = Vector3.zero;
        m_forceVec = Vector3.zero;
        m_resultVec = Vector3.zero;
        m_lookWPos = Vector3.zero;

        // m_proxyLook은, 각종 축 관련 옵션에 상관 없이 숨어서 타겟을 LookAt 하는 노드
        // 유니티의 LookAt은 Z축으로만 바라볼 수 있어서 이 노드가 타겟을 Z축으로 바라본다.
        m_proxyLook = new GameObject("SoxAtkJiggleboneProxyLook_" + transform.name).transform;
        m_proxyLook.parent = m_targetRoot;
        m_proxyLook.hideFlags = HideFlags.HideInHierarchy;
        m_proxyLook.localPosition = Vector3.zero;
        m_proxyLook.localRotation = Quaternion.identity;
        m_proxyLook.localScale = Vector3.one;

        // m_proxyAlign은, m_proxyLook의 자식으로서 각종 축 옵션이 반영되어서 90도 단위로 회전된 상태의 노드.
        // 최종 룩앳 본이 이것에 정렬됨
        m_proxyAlign = new GameObject("SoxAtkJiggleboneProxyAlign_" + transform.name).transform;
        m_proxyAlign.parent = m_proxyLook;
        m_proxyAlign.hideFlags = HideFlags.HideInHierarchy;
        m_proxyAlign.localPosition = Vector3.zero;
        m_proxyAlign.localRotation = Quaternion.identity;
        m_proxyAlign.localScale = Vector3.one;

        m_beforTargetWPos = m_target.position;
        m_beforeInerciaVec = Vector3.zero;

        SetOptions();

        m_initialized = true;
    }

    // 누가 우두머리인지 결정한다. m_head, m_tree 결정
    private void SetHead()
    {
        // 부모가 없거나 부모 지글본이 없으면 내가 우두머리다. 아무것도 안하고 그냥 리턴
        if (meTrans.parent == null)
            return;
        SoxAtkJiggleBone headJiggleBone = meTrans.parent.GetComponent<SoxAtkJiggleBone>();
        if (headJiggleBone == null)
            return;
        // 부모 지글본이 꺼져있으면 역시 내가 우두머리다.
        if (headJiggleBone.enabled == false)
            return;

        // 이후 부모 지글본이 있는 경우

        // while 로 진짜 헤드 찾기. 초기화가 무작위로 되기때문에 헤드의 헤드의 헤드의 헤드가 진짜 해드일 수 있다.
        bool found = false;
        while (!found)
        {
            if (headJiggleBone.m_head)
            {
                found = true;
            }
            else
            {
                // 헤드의 헤드 찾기
                headJiggleBone = headJiggleBone.m_tree[0];
            }
        }

        // 자신의 트리를 헤드 트리의 밑으로 더한다.
        // 헤드의 Start 함수가 작동 했을 수도 있고 안했을 수도 있다. m_treeInit을 검사해야함
        if (!headJiggleBone.m_treeInit)
        {
            // 초기화 안했으면 대신 초기화 해준다.
            headJiggleBone.m_tree = new SoxAtkJiggleBone[] { headJiggleBone };
            headJiggleBone.m_treeInit = true;
        }

        headJiggleBone.m_tree = ArrayAdd(headJiggleBone.m_tree, m_tree);

        // 나는 더이상 헤드가 아니다.
        m_head = false;

        // 내 헤드는 headJiggleBone이다.
        m_tree = new SoxAtkJiggleBone[] { headJiggleBone };
    }

    private SoxAtkJiggleBone[] ArrayAdd(SoxAtkJiggleBone[] arrA, SoxAtkJiggleBone[] arrB)
    {
        if (arrA == null && arrB != null)
            return arrB;
        if (arrA != null && arrB == null)
            return arrA;
        if (arrA == null && arrB == null)
            return null;

        SoxAtkJiggleBone[] returnArr = new SoxAtkJiggleBone[arrA.Length + arrB.Length];
        Array.Copy(arrA, 0, returnArr, 0, arrA.Length);
        Array.Copy(arrB, 0, returnArr, arrA.Length, arrB.Length);

        return returnArr;
    }

    void Update()
    {
        // 헤드인 경우에만 tree를 업데이트 한다.
        if (m_head)
        {
            for (int i = 0; i < m_tree.Length; i++)
            {
                m_tree[i].JiggleBoneUpdate();
            }
        }
    }

    public void JiggleBoneUpdate()
    {
        m_targetRoot.position = meTrans.position;
        m_targetRoot.localScale = meTrans.localScale;

        switch (m_simType)
        {
            // 이번 프레임의 포스벡터와 이전 프레임의 관성벡터를 Time.deltaTime과 연동하는 로직에서
            // 프레임레이트가 떨어질 수록 (Time.deltaTime이 커질 수록) 더 오래 진동하는 증세가 있다.
            // 이 오차는 FixedUpdate가 아니여서 발생하는 오차임. Fixed로 바꿀 경우 프레임레이트를 심하게 떨어뜨릴 수 있다.
            // 정확한 다이나믹 연산을 필요로 하는 경우를 위해 추후 FixedUpdate 옵션 추가를 검토
            case SimType.Simple:
                // 이번 이동에서 발생한 포스 벡터
                m_forceVec = (m_target.position - m_beforTargetWPos);
                // 이전 관성을 더한 뒤 텐션 적용한 결과 벡터
                m_resultVec = m_forceVec * Mathf.Min(1.0f, (m_tensionProxy * Time.deltaTime)) + m_beforeInerciaVec * m_inercia;
                m_lookWPos = m_beforTargetWPos + m_resultVec;
                break;
            case SimType.KeepDistance:
                // 본 끝이 저번 프레임 위치에 있지만 본 길이를 유지했을 경우의 월드 포지션
                m_boneEndDragWPos = (m_beforTargetWPos - meTrans.position).normalized * m_targetDistance + meTrans.position;
                // 이번 이동에서 발생한 포스 벡터 (본 길이를 감안한 포스), 비스듬하게 바라보면서 본 길이때문에 살짝 짧아지는 벡터가 된다.
                m_forceVec = (m_target.position - m_boneEndDragWPos);
                // 이전 관성을 더한 뒤 텐션 적용한 결과 벡터
                m_resultVec = m_forceVec * Mathf.Min(1.0f, (m_tensionProxy * Time.smoothDeltaTime)) + m_beforeInerciaVec * m_inercia;
                m_lookWPos = m_boneEndDragWPos + m_resultVec;
                break;
        }

        // m_upVector변수 세팅
        if (m_upnodeControl == UpnodeControl.AxisAlignment)
        {
            // Upnode Control : AxisAlignment
            // 업벡터의 기준이 월드가 아닌 오브젝트일 때에만 매 프레임 업데이트 한다. (오브젝트가 회전할 수 있으므로)
            if (!m_upWorld && m_upNode != null)
            {
                switch (m_upNodeAxis)
                {
                    case Axis.X:
                        m_upVector = m_upNode.right;
                        break;
                    case Axis.Y:
                        m_upVector = m_upNode.up;
                        break;
                    case Axis.Z:
                        m_upVector = m_upNode.forward;
                        break;
                }
            }
        }
        else
        {
            // Upnode Control : LookAt
            if (!m_upWorld && m_upNode != null)
            {
                m_upVector = m_upNode.position - meTrans.position;
            }
        }

        try
        {
            m_proxyLook.LookAt(m_lookWPos, m_upVector);
            meTrans.rotation = m_proxyAlign.rotation;
        }
        catch { }

        m_beforTargetWPos = m_lookWPos;
        m_beforeInerciaVec = m_resultVec;
    }

    private void OnDrawGizmos()
    {
        if (!this.enabled)
            return;

        float gizmoSize = m_optGizmoSize * transform.lossyScale.x;
        if (Application.isPlaying)
        {
            // Playing
            if (m_optShowGizmosAtPlaying)
            {
                Gizmos.color = Color.yellow;
                Gizmos.DrawLine(meTrans.position, m_target.position);
                Gizmos.DrawWireSphere(m_target.position, gizmoSize);

                Gizmos.color = Color.green;
                Gizmos.DrawLine(meTrans.position, m_lookWPos);
                Gizmos.DrawWireSphere(m_lookWPos, gizmoSize * 0.6f);
            }
        }
        else
        {
            // Editor
            if (m_optShowGizmosAtEditor)
            {
                Vector3 targetPos = Vector3.zero;
                float targetFlip = m_targetFlip ? -1.0f : 1.0f;
                switch (m_lookAxis)
                {
                    case Axis.X:
                        targetPos = transform.TransformPoint(new Vector3(m_targetDistance * targetFlip, 0.0f, 0.0f));
                        break;
                    case Axis.Y:
                        targetPos = transform.TransformPoint(new Vector3(0.0f, m_targetDistance * targetFlip, 0.0f));
                        break;
                    case Axis.Z:
                        targetPos = transform.TransformPoint(new Vector3(0.0f, 0.0f, m_targetDistance * targetFlip));
                        break;
                }

                Gizmos.color = Color.yellow;
                Gizmos.DrawLine(transform.position, targetPos);
                Gizmos.DrawWireSphere(targetPos, gizmoSize);
            }
        }
    }

    //m_lookAxis의 옵션에 따라서 m_target의 위치를 변경한다. m_targetDistance의 거리가 달라질 경우에도 사용된다.
    public void SetTargetDistance()
    {
        if (m_target == null)
            return;

        float targetFlip = m_targetFlip ? -1.0f : 1.0f;

        switch (m_lookAxis)
        {
            case Axis.X:
                m_target.localPosition = new Vector3(m_targetDistance * targetFlip, 0.0f, 0.0f);
                break;
            case Axis.Y:
                m_target.localPosition = new Vector3(0.0f, m_targetDistance * targetFlip, 0.0f);
                break;
            case Axis.Z:
                m_target.localPosition = new Vector3(0.0f, 0.0f, m_targetDistance * targetFlip);
                break;
        }
    }

    // 마이너스 스케일에서는 에디터 기즈모는 제대로 플립되지만 실제 연산용 포지션은 플립되지 않는 것이 문제임
    // 여러 선택사항들을 반영하는 함수 (필드가 변경될 때만 호출됨)
    public void SetOptions()
    {
        if (!Application.isPlaying)
            return;

        // m_proxyAlign 제어를 EulerAngle 방식으로 하니 답이 안나옴.
        // m_proxyAlign 제어에 대해서, alignLookPos 의 로컬 축 위치를 LookAt 으로 바라보는 방식으로 접근함
        // transform.right 혹은 transform.up 이런 것 사용하면 안됨, 이유는 마이너스 스케일에서 마이너스가 반영된 방향을 못 잡아냄
        Vector3 alignLookPos = Vector3.zero;
        Vector3 alignUpVector = Vector3.one;
        switch (m_lookAxis)
        {
            //m_lookAxis
            case Axis.X:
                switch (m_sourceUpAxis)
                {
                    case Axis.Y:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)) - m_proxyLook.position; } // up
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)) - m_proxyLook.position; } // -up
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)) - m_proxyLook.position; } // up
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)) - m_proxyLook.position; } // -up
                        break;
                    case Axis.Z:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)) - m_proxyLook.position; } // right
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)) - m_proxyLook.position; } // -right
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)) - m_proxyLook.position; } // -right
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)) - m_proxyLook.position; } // right
                        break;
                }
                break;
            
            //m_lookAxis
            case Axis.Y:
                switch (m_sourceUpAxis)
                {
                    case Axis.X:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)) - m_proxyLook.position; } // forward
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)) - m_proxyLook.position; } // forward
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, 0, -1)) - m_proxyLook.position; } // -forward
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, 0, -1)) - m_proxyLook.position; } // -forward
                        break;
                    case Axis.Z:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)) - m_proxyLook.position; } // forward
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)) - m_proxyLook.position; } // forward
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, 0, -1)) - m_proxyLook.position; } // -forward
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, -1, 0)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, 0, -1)) - m_proxyLook.position; } // -forward
                        break;
                }
                break;
            
            //m_lookAxis
            case Axis.Z:
                switch (m_sourceUpAxis)
                {
                    case Axis.X:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)) - m_proxyLook.position; } // -right
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)) - m_proxyLook.position; } // right
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, -1)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(1, 0, 0)) - m_proxyLook.position; } // right
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, -1)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(-1, 0, 0)) - m_proxyLook.position; } // -right
                        break;
                    case Axis.Y:
                        if (!m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)) - m_proxyLook.position; } // up
                        if (!m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, 1)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, -1, 0)) - m_proxyLook.position; } // -up
                        if (m_lookAxisFlip && !m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, -1)); alignUpVector = m_proxyLook.TransformPoint(new Vector3(0, 1, 0)) - m_proxyLook.position; } // up
                        if (m_lookAxisFlip && m_sourceUpAxisFlip) { alignLookPos = m_proxyLook.TransformPoint(new Vector3(0, 0, -1)); alignUpVector = -m_proxyLook.TransformPoint(new Vector3(0, -1, 0)) - m_proxyLook.position; } // -up
                        break;
                }
                break;
        }

        m_proxyAlign.LookAt(alignLookPos, alignUpVector);

        if (m_upWorld || m_upNode == null)
        {
            switch (m_upNodeAxis)
            {
                case Axis.X:
                    m_upVector = Vector3.right;
                    break;
                case Axis.Y:
                    m_upVector = Vector3.up;
                    break;
                case Axis.Z:
                    m_upVector = Vector3.forward;
                    break;
            }
        }
    }

    public void SetHiddenNodes()
    {
        if (!Application.isPlaying)
            return;

        if (m_optShowHiddenNodes)
        {
            m_targetRoot.hideFlags = HideFlags.None;
            m_target.hideFlags = HideFlags.None;
            m_proxyLook.hideFlags = HideFlags.None;
            m_proxyAlign.hideFlags = HideFlags.None;
        }
        else
        {
            m_targetRoot.hideFlags = HideFlags.HideInHierarchy;
            m_target.hideFlags = HideFlags.HideInHierarchy;
            m_proxyLook.hideFlags = HideFlags.HideInHierarchy;
            m_proxyAlign.hideFlags = HideFlags.HideInHierarchy;
        }
        m_hierarchyChanged = true;
    }

    void OnValidate()
    {
        EnsureGoodVars();
        // OnValidate 는 Awake보다 앞서 한번 호출된다.
        // Awake에서 m_target m_targetRoot m_proxyLook m_proxyAlign을 생성하기 전에 다음 함수들이 실행되는 것을 막기 위해 m_targetRoot만 하나 검사
        if (m_targetRoot != null)
        {
            SetTargetDistance();
            SetOptions();
            SetHiddenNodes();
        }
    }

    // 옵션 등의 변수가 적절하도록 강제함
    // 원래 에디터 스크립트에 있던 함수인데 여러 오브젝트를 동시에 편집하기 위해서 시리얼라이즈를 하다보니
    // 에디터에서는 변수에 직접 접근을 하면 그 순간 전체가 한꺼번에 바뀌는 부작용이 생긴다.(시리얼라이즈 관련 작업을 잘 몰라서일지도)
    // 그래서 변수의 무결성 검사는 각자에게 위임하도록 방식을 변경했음.
    // Start 없이 데이터에서 불리는 함수이므로 meTrans 사용하지 않고 transform 사용함
    public void EnsureGoodVars()
    {
        m_tensionProxy = Mathf.Max(0.0f, m_tension) * mc_tensionMul;
        //m_inercia = Mathf.Max(0.0f, m_inercia);
        m_targetDistance = Mathf.Max(0.0f, m_targetDistance);
        m_optGizmoSize = Mathf.Max(0.0f, m_optGizmoSize);

        if (m_upNodeAutoSet == false)
        {
            if (transform.parent != null)
            {
                m_upNode = transform.parent;
            }
            m_upNodeAutoSet = true; // 업노드가 등록 되던 말던 이 다시 이 기능을 하면 안됨
        }

        // 자기 자신을 업노드로 등록했는지 검사
        // 컴포넌트를 Copy & Paste 한다거나 여러 이유로 자기 자신이 들어갈 수 있음
        if (m_upNode == transform)
        {
            m_upNode = null;
        }

        // 바라보는 축과 소스업 축이 같으면 강제로 다르게 해야함
        if (m_lookAxis == m_sourceUpAxis)
        {
            m_sourceUpAxis = m_sourceUpAxisBefore;
        }

        // 그래도 바라보는 축과 소스업 축이 같으면 (Look Axis를 Source Up Axis에 강제로 맞춘 경우)
        if (m_lookAxis == m_sourceUpAxis)
        {
            switch (m_lookAxis)
            {
                case SoxAtkJiggleBone.Axis.X:
                    m_sourceUpAxis = SoxAtkJiggleBone.Axis.Y;
                    break;
                case SoxAtkJiggleBone.Axis.Y:
                    m_sourceUpAxis = SoxAtkJiggleBone.Axis.X;
                    break;
                case SoxAtkJiggleBone.Axis.Z:
                    m_sourceUpAxis = SoxAtkJiggleBone.Axis.Y;
                    break;
            }
        }

        // EnsureGoodVars함수가 에디터의 OnEnable에서 항상 불리기때문에 m_sourceUpAxisBefore의 초기화 걱정은 없음
        m_sourceUpAxisBefore = m_sourceUpAxis;
    }

    // 텐타클과 연동할 때 텐타클이 m_targetRoot를 얻어갈 수 있도록 리턴하는 함수
    public Transform GetTargetRoot()
    {
        return m_targetRoot;
    }

    // 텐타클에서 지글본 스크립트가 active인지 리플랙션으로 알아내려면 Invoke용 함수 필요
    public bool GetThisEnabled()
    {
        return this.enabled;
    }
}
