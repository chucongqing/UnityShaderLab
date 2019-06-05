using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mesh1 : MonoBehaviour
{

    Vector3[] newVertices = {
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),

        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),

        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),
        new Vector3(0, 0, 0),

        };
    Vector3[] leftVertices = {
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),

        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0)
    };
    Vector3[] rightVertices = {
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),

        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0)
    };
    Vector3[] newNormals = {
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 0),
    };
    Vector3[] leftNormals = {
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0)
    };
    Vector3[] rightNormals = {
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0),
        new Vector3 (0, 0, 0)
    };
    Vector2[] newUV = {
        new Vector2(0, 0),
        new Vector2(0, 1),
        new Vector2(1, 1),
        new Vector2(1, 0),

        new Vector2(0, 0),
        new Vector2(0, 1),
        new Vector2(1, 1),
        new Vector2(1, 0),

        new Vector2(0, 0),
        new Vector2(0, 1),
        new Vector2(1, 1),
        new Vector2(1, 0),

    };
    Vector2[] leftUV = {
        new Vector2 (0, 0),
        new Vector2 (0, 1),
        new Vector2 (1, 1),
        new Vector2 (1, 0),
        new Vector2 (0, 0),
        new Vector2 (0, 1),
        new Vector2 (1, 1),
        new Vector2 (1, 0)
    };
    Vector2[] rightUV = {
        new Vector2 (0, 0),
        new Vector2 (0, 1),
        new Vector2 (1, 1),
        new Vector2 (1, 0),
        new Vector2 (0, 0),
        new Vector2 (0, 1),
        new Vector2 (1, 1),
        new Vector2 (1, 0)
    };

    public static int[] leftTriangles = { 0, 6, 7, 0, 7, 3, 4, 1, 2, 4, 2, 5 };
    public static int[] rightTriangles = { 0, 6, 7, 0, 7, 3, 4, 1, 2, 4, 2, 5 };

    //int[] newTriangles = {  0,1,2, 2,3,0, 1,5,2, 5,6,2, 5,9,6, 10,6,9};
    static int[] AllShow = { 0, 1, 2, 2, 3, 0,   4, 5, 7,   5, 6, 7,   9, 10, 8,   10, 11, 8 };

    public float wallheight = 3f, wallwidth = 3f, walllength = 4.0f, windowtop = 2f, windowbottom = 1f;
    [HideInInspector] public Vector3 shangyouvector;

    public Vector3 direction;

    //[SerializeField] private GameObject beginpoint;

    [SerializeField] private Material wallMaterial, jiefengMaterial;


    private GameObject wallobj, leftwallobj, rightwallobj;

    private Mesh wallMesh, leftWallMesh, rightWallMesh;

    // Start is called before the first frame update
    void Start()
    {
        wallobj = new GameObject("wall");
        wallobj.transform.SetParent(this.transform);

        var wallmf = wallobj.AddComponent<MeshFilter>();
        wallmf.mesh = wallMesh = new Mesh();

        var wallr = wallobj.AddComponent<MeshRenderer>();
        wallr.material = new Material(jiefengMaterial);

        var sharedM = new Material(wallMaterial);
        leftwallobj = new GameObject("leftwallobj");
        leftwallobj.transform.SetParent(this.transform);

        var leftwallmf = leftwallobj.AddComponent<MeshFilter>();
        leftwallmf.sharedMesh = leftWallMesh = new Mesh();

        var leftwallr = leftwallobj.AddComponent<MeshRenderer>();
        leftwallr.sharedMaterial = sharedM;


        rightwallobj = new GameObject("rightwallobj");
        rightwallobj.transform.SetParent(this.transform);

        var rightwallmf = rightwallobj.AddComponent<MeshFilter>();
        rightwallmf.sharedMesh = leftWallMesh; // = new Mesh();

        var rightwallr = rightwallobj.AddComponent<MeshRenderer>();
        rightwallr.sharedMaterial = sharedM;


    }

    // Update is called once per frame
    void Update()
    {
        
    }

    static Vector3 Normal1 = new Vector3(0, -1f, 0);
    static Vector3 Normal2 = new Vector3(0, 1f, 0);
    private static Quaternion QN90 = Quaternion.Euler(0, -90f, 0);
    private static Quaternion Q90 = Quaternion.Euler(0, 90f, 0);

    public void ReCalculateWalllength()
    {
        //if (beginpoint == null || endpoint == null)
        //{
        //    GameObject.Destroy(this.gameObject);
        //    return;
        //}

        //walllength = Convert.ToSingle(Math.Round((double)((endpoint.transform.position - beginpoint.transform.position).magnitude), 3));
        //direction = Vector3.Normalize(endpoint.transform.position - beginpoint.transform.position);
        Debug.Log("Direction > " + direction);
        shangyouvector = Q90 * direction;
        //xiayouvector = Q90 * direction;
    }

    public void ReCalculateVertices()
    {
        //if (beginpoint == null)
        //{
        //    for (int i = 0; i < newVertices.Length; i++)
        //    {
        //        newVertices[i].Set(0f, 0f, 0f);
        //    }
        //    for (int i = 0; i < leftVertices.Length; i++)
        //    {
        //        leftVertices[i].Set(0f, 0f, 0f);
        //    }
        //    for (int i = 0; i < rightVertices.Length; i++)
        //    {
        //        rightVertices[i].Set(0f, 0f, 0f);
        //    }
        //    return;
        //}

        var beinPos = Vector3.zero; //beginpoint.transform.position;

        //   static int[] AllShow = { 0, 1, 2,   2, 3, 0,    1, 5, 2,    5, 6, 2,   5, 9, 6,    10, 6, 9 };
        newVertices[0] = beinPos + (-0.5f * shangyouvector * wallwidth);
      
        newVertices[1].Set(newVertices[0].x, newVertices[0].y + wallheight, newVertices[0].z);
       
        newVertices[3] = beinPos + (0.5f * shangyouvector * wallwidth);
       
        newVertices[2] = new Vector3(newVertices[3].x, newVertices[3].y + wallheight, newVertices[3].z);
      
        newVertices[4] = newVertices[1];
        newVertices[7] = newVertices[2];

        newVertices[5] = newVertices[4] + direction * walllength;
        newVertices[6] = newVertices[7] + direction * walllength;
        newVertices[8] = newVertices[5];
        newVertices[11] = newVertices[6];
        newVertices[9] = newVertices[0] + direction * walllength;
        newVertices[10] = newVertices[3] + direction * walllength;



        //var idx = 0;
        //foreach (var vertex in newVertices)
        //{
        //    Debug.Log(idx++  + " : " +vertex);
        //}

        //  public static int[] leftTriangles = { 0, 6, 7,  0, 7, 3,  4, 1, 2,  4, 2, 5 };
        leftVertices[0] = newVertices[9];
        leftVertices[1] = newVertices[8];
        leftVertices[2] = newVertices[1];
        leftVertices[3] = newVertices[0];

        leftVertices[4] = leftVertices[0]; /*Set(leftVertices[0].x, leftVertices[0].y + windowtop, leftVertices[0].z);*/
        leftVertices[4].y += windowtop;

        leftVertices[5].Set(leftVertices[3].x, leftVertices[3].y + windowtop, leftVertices[3].z);
        leftVertices[6].Set(leftVertices[0].x, leftVertices[0].y + windowbottom, leftVertices[0].z);
        leftVertices[7].Set(leftVertices[3].x, leftVertices[3].y + windowbottom, leftVertices[3].z);

        
        //var idx = 0;
        //foreach (var vertex in leftVertices)
        //{
        //    Debug.Log(idx++ + " : " + vertex);
        //}

        //rightVertices[0] = newVertices[3];
        //rightVertices[1] = newVertices[2];
        //rightVertices[2] = newVertices[11];
        //rightVertices[3] = newVertices[10];
        //rightVertices[4].Set(rightVertices[0].x, rightVertices[0].y + windowtop, rightVertices[0].z);
        //rightVertices[5].Set(rightVertices[3].x, rightVertices[3].y + windowtop, rightVertices[3].z);
        //rightVertices[6].Set(rightVertices[0].x, rightVertices[0].y + windowbottom, rightVertices[0].z);
        //rightVertices[7].Set(rightVertices[3].x, rightVertices[3].y + windowbottom, rightVertices[3].z);

    ;

    }


    public void ReCalculateUV()
    {
        leftUV[0].Set(0, 0);
        leftUV[1].Set(0, 1);
        leftUV[2].Set(1, 1);
        leftUV[3].Set(1, 0);

        leftUV[4].Set(0, windowtop / wallheight);
        leftUV[5].Set(1, windowtop / wallheight);
        leftUV[6].Set(0, windowbottom / wallheight);
        leftUV[7].Set(1, windowbottom / wallheight);

    }


    public void toreset()
    {
       

        ReCalculateWalllength();
        ReCalculateVertices();
        ReCalculateUV();


        wallobj.transform.position = Vector3.zero;

        leftwallobj.transform.position = Vector3.zero;

        rightwallobj.transform.position = Vector3.zero;

        var wallObjMesh = wallMesh;

        wallObjMesh.vertices = newVertices;
        wallObjMesh.uv = newUV;

        wallObjMesh.triangles = AllShow;
        wallObjMesh.normals = newNormals;
        wallObjMesh.RecalculateNormals();
        wallObjMesh.RecalculateTangents();

        var _localScale = this.transform.localScale;

        var transform_localScale = new Vector3(1 / _localScale.x, 1 / _localScale.y, 1 / _localScale.z);

        wallobj.transform.localScale = transform_localScale;

        var leftwallObjMesh = leftWallMesh;

        leftwallObjMesh.vertices = leftVertices;
        leftwallObjMesh.uv = leftUV;
        leftwallObjMesh.triangles = leftTriangles;
        leftwallObjMesh.normals = leftNormals;
        leftwallObjMesh.RecalculateNormals();
        leftwallObjMesh.RecalculateTangents();

        leftwallobj.transform.localScale = transform_localScale;


        //var rightwallObjMesh = rightWallMesh;

        //rightwallObjMesh.vertices = rightVertices;
        //rightwallObjMesh.uv = rightUV;
        //rightwallObjMesh.triangles = rightTriangles;
        //rightwallObjMesh.normals = rightNormals;
        //rightwallObjMesh.RecalculateNormals();
        //rightwallObjMesh.RecalculateTangents();

        transform_localScale.z = -transform_localScale.z;
        rightwallobj.transform.localScale = transform_localScale;
    }
}
