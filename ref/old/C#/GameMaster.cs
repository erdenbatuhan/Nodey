using UnityEngine;
using System.Collections;

public class GameMaster : MonoBehaviour {

    public int level;
    public AudioClip swapSound, popSound;
    public GameObject popEffect;
    public GameObject[] connectors, nodes;
	private int treeSize;
	private bool isBeingSwapped = false;
    private const float distance = 0.99f;

    private void OnGUI() {
        GUI.Box(new Rect(10, 10, 25, 25), "" + (treeSize - 1));
    } // .OnGUI()

    private void Start() {
        treeSize = nodes.Length - 1;
		isBeingSwapped = false;
    } // .Start()

    private void Update() {
        if (treeSize == 1)
            Invoke("restart", 2);

// If the game is running on Unity Editor (PC)
#if UNITY_EDITOR

        if (Input.GetMouseButtonDown(0)) {
            Vector2 tp = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            int thatChild = getNode(tp);

            if (thatChild != -1 && nodes[thatChild].tag != "NULL") {
                swap(thatChild);

                for (int i = nodes.Length - 2; i >= 2; i -= 2)
                    if (nodes[i] != null && nodes[i].tag != "NULL" && nodes[i + 1] != null && nodes[i + 1].tag != "NULL")
                        StartCoroutine(pop(i, false));
            }
        }

// If the game is running on iOS or Android (Touch Screen)
#elif UNITY_IOS || UNITY_ANDROID

		if (Input.touchCount > 0) {
			Touch myTouch = Input.touches[0];

			if (myTouch.phase == TouchPhase.Began) {
                Vector2 tp = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                int thatChild = nodeSearch(tp);

                if (thatChild != -1 && nodes[thatChild].tag != "NULL") {
                    swap(thatChild);

                    for (int i = nodes.Length - 2; i >= 2; i -= 2)
                        if (nodes[i] != null && nodes[i].tag != "NULL" && nodes[i + 1] != null && nodes[i + 1].tag != "NULL")
                            StartCoroutine(pop(i, false));
            	}
			}
		}
		
#endif
    } // .Update()

    private IEnumerator move(GameObject obj, Vector2 direction) {
        if (obj.tag != "NULL") {
            Rigidbody2D r = obj.GetComponent<Rigidbody2D>();
            float sqrRemainingDistance = (r.position - direction).sqrMagnitude;

            while (sqrRemainingDistance > float.Epsilon) {
                Vector2 newPosition = Vector2.MoveTowards(r.position, direction, 25 * Time.deltaTime);
                r.MovePosition(newPosition);
                sqrRemainingDistance = (r.position - direction).sqrMagnitude;

                yield return null;
            }

            r.position = direction;
            obj.transform.position = direction;
            isBeingSwapped = false;
        }
    } // .move(GameObject obj, Vector2 direction)

    private int getNode(Vector2 tp) {
        int thatChild = -1;

        for (int i = 2; i < nodes.Length; i++) {
            if (nodes[i] != null && nodes[i].tag != "NULL") {
                float targetx = nodes[i].transform.position.x;
                float targety = nodes[i].transform.position.y;

                if (tp.x >= targetx - distance && tp.x <= targetx + distance && tp.y >= targety - distance && tp.y <= targety + distance) {
                    thatChild = i;
                    break;
                }
            }
        }

        return thatChild;
    } // .getNode(Vector2 tp)

    private void swap(int child) {
        if (!isBeingSwapped) {
            isBeingSwapped = true;
            int parent = child / 2;

            if (nodes[parent] != null && nodes[child] != null && nodes[parent].tag != "NULL" && nodes[child].tag != "NULL") {
                AudioSource.PlayClipAtPoint(swapSound, Vector3.zero);
                Vector2 childpos = nodes[child].transform.position;

                StartCoroutine(move(nodes[child], nodes[parent].transform.position));
                StartCoroutine(move(nodes[parent], childpos));

                GameObject tmp = nodes[child];
                nodes[child] = nodes[parent];
                nodes[parent] = tmp;
            }
        }
    } // .swap(int child)

    private IEnumerator pop(int leftchild, bool isBeingDoublePopped) {
        if (!isBeingDoublePopped)
            yield return new WaitForSeconds(0.25f);

        int rightchild = leftchild + 1;
        bool popAgain = canPopAgain(leftchild);

        if (nodes[leftchild].tag == nodes[rightchild].tag) {
            if (doHaveChild(leftchild)) {
                Application.LoadLevel(level);
                yield return null;
            }

            AudioSource.PlayClipAtPoint(popSound, Vector3.zero);

            nodes[leftchild].GetComponent<Rigidbody2D>().isKinematic = false;
            nodes[rightchild].GetComponent<Rigidbody2D>().isKinematic = false;
            nodes[leftchild].tag = "NULL";
            nodes[rightchild].tag = "NULL";

            GameObject leftPopEffect = Instantiate(popEffect);
            leftPopEffect.transform.position = connectors[leftchild].transform.position;
            GameObject rightPopEffect = Instantiate(popEffect);
			rightPopEffect.transform.position = connectors[rightchild].transform.position;

			Destroy(leftPopEffect, 3);
			Destroy(rightPopEffect, 3);
            destroyConnectors(leftchild);
            Destroy(nodes[leftchild], 3);
            Destroy(nodes[rightchild], 3);

            treeSize -= 2;

            if (popAgain)
                StartCoroutine(pop(leftchild / 2, true));

            yield return null;
        }
    } // .pop(int leftchild, bool isBeingDoublePopped)

    private void destroyConnectors(int leftchild) {
        int rightchild = leftchild + 1;

        Destroy(connectors[leftchild]);
        Destroy(connectors[rightchild]);
    } // .destroyConnectors(int leftchild)

    private bool doHaveChild(int leftParent) {
        int rightParent = leftParent + 1; 			// Sibling of Left Parent (Right Parent)
        int leftLeftChild = leftParent * 2; 		// Left Child of Left Parent
		int leftRightChild = leftLeftChild + 1; 	// Right Child Of Left Parent
        int rightLeftChild = rightParent * 2; 		// Left Child Of Right Parent
		int rightRightChild = rightLeftChild + 1;  // Right Child Of Right Parent
        bool case1 = true, case2 = true, case3 = true, case4 = true;

        if (leftLeftChild < nodes.Length && leftRightChild < nodes.Length && rightLeftChild < nodes.Length && rightRightChild < nodes.Length) {
            case1 = nodes[leftLeftChild] == null   || nodes[leftLeftChild].tag == "NULL";
            case2 = nodes[leftRightChild] == null  || nodes[leftRightChild].tag == "NULL";
            case3 = nodes[rightLeftChild] == null  || nodes[rightLeftChild].tag == "NULL";
            case4 = nodes[rightRightChild] == null || nodes[rightRightChild].tag == "NULL";
        }

        if (case1 & case2 & case3 & case4)
            return false;
        else
            return true;
    } // .doHaveChild(int leftParent)

    private bool canPopAgain(int child) {
        bool answer = false;
        int parent = child / 2;
        int grandParent = parent / 2;
        int leftParent = grandParent * 2;           // Left Child of Grandparent (Left Parent)
        int rightParent = leftParent + 1;           // Right Child of Grandparent (Right Parent)
        int leftLeftChild = leftParent * 2;         // Left Child of Left Parent
		int leftRightChild = leftLeftChild + 1;     // Right Child Of Left Parent
        int rightLeftChild = rightParent * 2;       // Left Child Of Right Parent
		int rightRightChild = rightLeftChild + 1;   // Right Child Of Right Parent

        if (child == leftLeftChild || child == leftRightChild) {
            bool case1 = (nodes[rightLeftChild] == null || nodes[rightLeftChild].tag == "NULL");
            bool case2 = (nodes[rightRightChild] == null || nodes[rightRightChild].tag == "NULL");
            answer = case1 && case2;
        } else if (child == rightLeftChild || child == rightRightChild) {
            bool case3 = (nodes[leftLeftChild] == null || nodes[leftLeftChild].tag == "NULL");
            bool case4 = (nodes[leftRightChild] == null || nodes[leftRightChild].tag == "NULL");
            answer = case3 && case4;
        }

        return answer;
    } // .canPopAgain(int child)

    private void load() {
        Application.LoadLevel(level + 1);
    } // .load()

    private void restart() {
        Application.LoadLevel(level);
    } // .restart()

    private int depthOf(int thatNode) {
    	if (thatNode >= nodes.Length && thatNode <= 1)
    		return 0;

    	if (thatNode <= 3)
    		return 1;

    	int z = 3;
    	int n = 2;
    	int depth = 1;

    	while(z < thatNode) {
    		z += (int) Mathf.Pow(2, n);
    		n++;
    		depth++;
    	}

    	return depth;
    } // .depthOf(int thatNode)
}
