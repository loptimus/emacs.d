package refactorerl.ui.core.assistants;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.Path;
import org.eclipse.ltk.core.refactoring.Change;
import org.eclipse.ltk.core.refactoring.TextFileChange;
import org.eclipse.text.edits.MultiTextEdit;
import org.eclipse.text.edits.TextEdit;
import org.erlide.wrangler.refactoring.util.ChangesetMaker;


/**
 * Represents an Erlang file, and a string which contains the modified source.
 * 
 * @author Gyorgy Orosz, modified by Gergely Horvath
 * @version %I%, %G%
 */
public class RefactorErlChangedFile {
	/**
	 * Represented Erlang file OS dependent path before the refactoring.
	 */
	String oldPath;

	/**
	 * Represented Erlang file OS dependent path after the refactoring.
	 */
	String newPath;

	/**
	 * Modified source of <code>oldPath</code>.
	 */
	String newFileContent;

	/**
	 * Constructs a new object.
	 * 
	 * @param oldPath
	 *            Old path of the file.
	 * @param newPath
	 *            New path of the file.
	 * @param newFileContent
	 *            New content of the source file.
	 */
	
	public RefactorErlChangedFile(String oldPath, String newPath) {
		IPath location = new Path(oldPath);
		location = location.addFileExtension("_referltmp");
		String newName = location.toPortableString();
		this.oldPath = newName;
		
		location = new Path(newPath);
		location = location.addFileExtension("_referltmp");
		newName = location.toPortableString();
		this.newPath = newName;//newPath;
        
		File file = new File(newPath);
		StringBuilder contents = new StringBuilder();
		
		try {
			BufferedReader input =  new BufferedReader(new FileReader(file));
			try {
				String line = null; 
				while (( line = input.readLine()) != null){
					contents.append(line);
					contents.append(System.getProperty("line.separator"));
				}
			}
			finally {
				input.close();
			}
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
		this.newFileContent = contents.toString();	
	}
	
	/**
	 * Creates <code>Change</code> objects from the original and the modified
	 * source.
	 * 
	 * @return the created <code>Change</code> object which typically instance
	 *         of <code>TextFileChange</code>
	 * @throws IOException
	 *             if an exception occurs while accessing the source file
	 */
	public Change createChanges() throws IOException {
		IFile eclipseRep = findEclipseRepresentation(oldPath);

		TextFileChange change = new TextFileChange(newPath, eclipseRep){
			@Override 
			public Change perform(IProgressMonitor pm)
			{
				return null;
			}
		};
		File tf = new File(oldPath);
		ArrayList<TextEdit> edits = ChangesetMaker.createEdits(tf,
				newFileContent);
		MultiTextEdit multiEdit = new MultiTextEdit();
		if (edits.size() != 0) {
			for (TextEdit edit : edits) {
				multiEdit.addChild(edit);
			}
			change.setEdit(multiEdit);
			return change;
		} else {
			return null;
		}
	}

	/**
	 * Finds the Eclipse representation of the given path.
	 * 
	 * @param anOldPath
	 *            OS dependent path of the refactored file
	 * @return an <code>IFile</code> object of the given path
	 * @throws IOException
	 *             if the given path could not be found on the workspace
	 */
	private IFile findEclipseRepresentation(String anOldPath)
			throws IOException {
		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IWorkspaceRoot root = workspace.getRoot();
		Path p = new Path(anOldPath);
		IFile file = root.getFileForLocation(p);
		if (file == null ) {
			throw new IOException("File not found");
		}

		return file;
	}

	/**
	 * True if the file name is changed during the refactoring.
	 * 
	 * @return
	 */
	public boolean isNameChanged() {
		return !newPath.equals(oldPath);
	}

	/**
	 * Returns the IPath object of the old path.
	 * 
	 * @return
	 */
	public IPath getIPath() {
		IFile f;
		try {
			f = findEclipseRepresentation(oldPath);
		} catch (IOException e) {
			return null;
		}
		return f.getFullPath();
	}

	/**
	 * If the refactoring changes the file name, it returns back the new one.
	 * 
	 * @return new file name
	 */
	public String getNewName() {
		IPath location = new Path(newPath);
		return location.toFile().getName();
		// return newPath;
	}
}
